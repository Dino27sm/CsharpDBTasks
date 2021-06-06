namespace VaporStore.DataProcessor.Dto.Export
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlType("User")]
    public class ExportUserDtoXML
    {
        [XmlAttribute("username")]
        public string Username { get; set; }

        [XmlArray("Purchases")]
        public List<CardDto> Purchases { get; set; }

        [XmlElement("TotalSpent")]
        public decimal TotalSpent { get; set; }
    }

    [XmlType("Purchase")]
    public class CardDto
    {
        [XmlElement("Card")]
        public string CardNumber { get; set; }

        [XmlElement("Cvc")]
        public string CvcNumber { get; set; }

        [XmlElement("Date")]
        public string Date { get; set; }

        [XmlElement("Game")]
        public GameDto Game { get; set; }
    }

    [XmlRoot(ElementName = "Game")]
    public class GameDto
    {
        [XmlAttribute(AttributeName = "title")]
        public string Title { get; set; }

        [XmlElement(ElementName = "Genre")]
        public string GenreName { get; set; }

        [XmlElement(ElementName = "Price")]
        public decimal Price { get; set; }
    }
}
