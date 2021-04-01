namespace CarDealer.DTO
{
    using CarDealer.Models;
    using System.Collections.Generic;

    public class CarPartsExportDto
    {
        public CarDto car { get; set; }
        public ICollection<PartDto> parts { get; set; } = new List<PartDto>();
    }
}
