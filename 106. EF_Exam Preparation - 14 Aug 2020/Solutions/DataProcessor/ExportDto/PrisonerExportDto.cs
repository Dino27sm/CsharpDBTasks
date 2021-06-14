namespace SoftJail.DataProcessor.ExportDto
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class PrisonerExportDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? CellNumber { get; set; }
        public ICollection<OfficerDto> Officers { get; set; }
        public decimal TotalOfficerSalary { get; set; }
    }

    public class OfficerDto
    {
        [Required]
        public string OfficerName { get; set; }
        public string Department { get; set; }
    }
}
