namespace CarDealer.DtoModels.InputDto
{
    using System.Xml.Serialization;

    [XmlType("partId")]
    public class PartCarInputDto
    {
        [XmlAttribute("id")]
        public int Id { get; set; }
    }
}
