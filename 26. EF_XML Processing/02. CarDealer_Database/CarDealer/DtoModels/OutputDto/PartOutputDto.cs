namespace CarDealer.DtoModels.OutputDto
{
    using System.Xml.Serialization;

    [XmlType("part")]
    public class PartOutputDto
    {
        [XmlAttribute("name")]
        public string Name { get; set; }

        [XmlAttribute("price")]
        public decimal Price { get; set; }
    }
}
