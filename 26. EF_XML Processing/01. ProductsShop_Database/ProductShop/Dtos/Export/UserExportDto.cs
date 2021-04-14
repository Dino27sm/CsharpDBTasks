﻿namespace ProductShop.Dtos.Export
{
    using ProductShop.Models;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlType("User")]
    public class UserExportDto
    {
        [XmlElement("firstName")]
        public string FirstName { get; set; }

        [XmlElement("lastName")]
        public string LastName { get; set; }

        [XmlArray("soldProducts")]
        public List<ProductExportDto> ProductsSold { get; set; } = new List<ProductExportDto>();
    }
}
