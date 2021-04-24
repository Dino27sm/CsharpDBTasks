namespace CarDealer.DtoModels.InputDto
{
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlType("Car")]
    public class CarInputDto
    {
        [XmlElement("make")]
        public string Make { get; set; }

        [XmlElement("model")]
        public string Model { get; set; }

        [XmlElement("TraveledDistance")]
        public long TravelledDistance { get; set; }

        [XmlArray("parts")]
        public List<PartCarInputDto> Parts { get; set; }
    }
}
