using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace BookShop.DataProcessor.ExportDto
{
    [XmlType("Book")]
    public class ExportOldestBookDtoXML
    {
        [XmlAttribute("Pages")]
        public string BookPages { get; set; }

        [XmlElement("Name")]
        public string BookName { get; set; }

        [XmlElement("Date")]
        public string BookPublished { get; set; }
    }
}
