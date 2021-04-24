namespace CarDealer.DtoModels.OutputDto
{
    using System.Xml.Serialization;

    [XmlType("car")]
    public class CarBmwOutputDto
    {
        [XmlAttribute("id")]
        public int Id { get; set; }

        [XmlAttribute("model")]
        public string Model { get; set; }

        [XmlAttribute("travelled-distance")]
        public string TravelledDistance { get; set; }
    }
}
