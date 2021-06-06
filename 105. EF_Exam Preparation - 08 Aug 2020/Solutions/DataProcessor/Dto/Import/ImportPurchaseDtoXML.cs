using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Xml.Serialization;
using VaporStore.Data.Models.Enums;

namespace VaporStore.DataProcessor.Dto.Import
{
    [XmlType("Purchase")]
    public class ImportPurchaseDtoXML
    {
        [XmlAttribute(AttributeName = "title")]
        public string Title { get; set; }

        [XmlElement("Type")]
        [Required]
        [EnumDataType(typeof(PurchaseType))]
        public string Type { get; set; }

        [XmlElement("Key")]
        [Required]
        [RegularExpression(@"[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}")]
        public string ProductKey { get; set; }

        [XmlElement("Card")]
        [Required]
        [RegularExpression(@"(\d{4}\s){3}\d{4}")]
        public string CardNumber { get; set; }

        [XmlElement("Date")]
        [Required]
        public string Date { get; set; }
    }
}
