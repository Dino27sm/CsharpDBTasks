namespace SoftJail.DataProcessor
{

    using Data;
    using Microsoft.EntityFrameworkCore;
    using Newtonsoft.Json;
    using SoftJail.DataProcessor.ExportDto;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml.Serialization;

    public class Serializer
    {
        public static string ExportPrisonersByCells(SoftJailDbContext context, int[] ids)
        {
            var prisonersDto = context.Prisoners
                .Where(p => ids.Contains(p.Id))
                .Include(a => a.PrisonerOfficers)
                .ToList()
                .Select(p => new PrisonerExportDto()
                {
                    Id = p.Id,
                    Name = p.FullName,
                    CellNumber = p.Cell.CellNumber,
                    Officers = p.PrisonerOfficers.Select(x => new OfficerDto()
                    {
                        OfficerName = x.Officer.FullName,
                        Department = x.Officer.Department.Name
                    })
                    .OrderBy(o => o.OfficerName)
                    .ToList(),
                    TotalOfficerSalary = p.PrisonerOfficers.Sum(y => y.Officer.Salary)
                })
                .OrderBy(pr => pr.Name)
                .ThenBy(pr => pr.Id)
                .ToList();

            return JsonConvert.SerializeObject(prisonersDto, Formatting.Indented);
        }

        public static string ExportPrisonersInbox(SoftJailDbContext context, string prisonersNames)
        {
            string[] namesOfPrisoners = prisonersNames.Split(",");

            var prisonersInfo = context.Prisoners
                .Where(p => namesOfPrisoners.Contains(p.FullName))
                .Select(p => new PrisonerExportDtoXML()
                {
                    Id = p.Id,
                    Name = p.FullName,
                    IncarcerationDate = p.IncarcerationDate.ToString("yyyy-MM-dd"),
                    MailMessages = p.Mails.Select(m => new MailDtoXML()
                    {
                        Description = string.Join("", m.Description.ToCharArray().Reverse())
                    }).ToList()
                })
                .OrderBy(s => s.Name)
                .ThenBy(s => s.Id)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<PrisonerExportDtoXML>), 
                                    new XmlRootAttribute("Prisoners"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, prisonersInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }
    }
}