namespace SoftJail.DataProcessor
{
    using AutoMapper;
    using Data;
    using Newtonsoft.Json;
    using SoftJail.Data.Models;
    using SoftJail.Data.Models.Enums;
    using SoftJail.DataProcessor.ImportDto;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml.Serialization;

    public class Deserializer
    {
        public static string ImportDepartmentsCells(SoftJailDbContext context, string jsonString)
        {
            var departmentsDto = JsonConvert.DeserializeObject<ICollection<ImportDepartmentCellDto>>(jsonString);

            StringBuilder sb = new StringBuilder();
            List<Department> departments = new List<Department>();

            foreach (var departmentItem in departmentsDto)
            {
                if (!IsValid(departmentItem) 
                    || !(departmentItem.Cells.Count > 0) 
                    || !departmentItem.Cells.TrueForAll(x => IsValid(x)))
                {
                    sb.AppendLine("Invalid Data");
                    continue;
                }

                Department department = new Department()
                {
                    Name = departmentItem.Name,
                    Cells = departmentItem.Cells.Select(x => new Cell()
                    {
                        CellNumber = x.CellNumber,
                        HasWindow = x.HasWindow
                    }).ToList()
                };
                departments.Add(department);
                sb.AppendLine($"Imported {department.Name} with {department.Cells.Count} cells");
            }
            context.Departments.AddRange(departments);
            context.SaveChanges();

            return sb.ToString().Trim();
        }

        public static string ImportPrisonersMails(SoftJailDbContext context, string jsonString)
        {
            var prisonersDto = JsonConvert.DeserializeObject<ICollection<ImportPrisonerMailDto>>(jsonString);

            StringBuilder sb = new StringBuilder();
            List<Prisoner> prisoners = new List<Prisoner>();

            foreach (var prisonerItem in prisonersDto)
            {
                if (!IsValid(prisonerItem) || !prisonerItem.Mails.All(IsValid))
                {
                    sb.AppendLine("Invalid Data");
                    continue;
                }

                bool isReleaseDate = DateTime.TryParseExact(prisonerItem.ReleaseDate, "dd/MM/yyyy",
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime releasedDate);

                var incarcerationDate = DateTime.ParseExact(prisonerItem.IncarcerationDate, "dd/MM/yyyy",
                    CultureInfo.InvariantCulture);

                Prisoner prisoner = new Prisoner()
                {
                    FullName = prisonerItem.FullName,
                    Nickname = prisonerItem.Nickname,
                    Age = prisonerItem.Age,
                    Bail = prisonerItem.Bail,
                    CellId = prisonerItem.CellId,
                    IncarcerationDate = incarcerationDate,
                    ReleaseDate = isReleaseDate ? (DateTime?)releasedDate : null,
                    Mails = prisonerItem.Mails.Select(p => new Mail()
                    {
                        Description = p.Description,
                        Sender = p.Sender,
                        Address = p.Address
                    }).ToList()
                };
                prisoners.Add(prisoner);
                sb.AppendLine($"Imported {prisoner.FullName} {prisoner.Age} years old");
            }
            context.Prisoners.AddRange(prisoners);
            context.SaveChanges();

            return sb.ToString().Trim();
        }

        public static string ImportOfficersPrisoners(SoftJailDbContext context, string xmlString)
        {
            var serializer = new XmlSerializer(typeof(List<OfficerPrisonerImportDtoXML>), 
                                    new XmlRootAttribute("Officers"));
            var deserializedOfficers = (ICollection<OfficerPrisonerImportDtoXML>)serializer
                                    .Deserialize(new StringReader(xmlString));

            StringBuilder sb = new StringBuilder();
            List<Officer> officers = new List<Officer>();

            foreach (var officerItem in deserializedOfficers)
            {
                if (!IsValid(officerItem))
                {
                    sb.AppendLine("Invalid Data");
                    continue;
                }

                Officer officer = new Officer()
                {
                    FullName = officerItem.FullName,
                    Salary = officerItem.Money,
                    Position = Enum.Parse<Position>(officerItem.Position),
                    Weapon = Enum.Parse<Weapon>(officerItem.Weapon),
                    DepartmentId = officerItem.DepartmentId,
                    OfficerPrisoners = officerItem.Prisoners.Select(x => new OfficerPrisoner
                    {
                        PrisonerId = x.Id
                    }).ToList()
                };
                officers.Add(officer);
                sb.AppendLine($"Imported {officer.FullName} ({officer.OfficerPrisoners.Count} prisoners)");
                //context.Officers.Add(officer);
                //context.SaveChanges();
            }
            context.Officers.AddRange(officers);
            context.SaveChanges();

            return sb.ToString().Trim();
        }

        private static bool IsValid(object obj)
        {
            var validationContext = new System.ComponentModel.DataAnnotations.ValidationContext(obj);
            var validationResult = new List<ValidationResult>();

            bool isValid = Validator.TryValidateObject(obj, validationContext, validationResult, true);
            return isValid;
        }
    }
}