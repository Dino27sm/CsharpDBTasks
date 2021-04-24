namespace CarDealer.DtoModels.OutputDto
{
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlType("car")]
    public class CarListOutputDto
    {
        [XmlAttribute("make")]
        public string Make { get; set; }

        [XmlAttribute("model")]
        public string Model { get; set; }

        [XmlAttribute("travelled-distance")]
        public string TravelledDistance { get; set; }

        [XmlArray("parts")]
        public List<PartOutputDto> PartCars { get; set; }
    }
}
