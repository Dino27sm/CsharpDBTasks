namespace CarDealer.DTO
{
    using CarDealer.Models;
    using System.Collections.Generic;

    public class CarsImportDto
    {
        public string make { get; set; }
        public string model { get; set; }
        public long travelledDistance { get; set; }
        public ICollection<int> partsId { get; set; } = new List<int>();
    }
}
