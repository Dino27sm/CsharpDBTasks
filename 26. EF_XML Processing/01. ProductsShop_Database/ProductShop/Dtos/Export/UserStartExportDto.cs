namespace ProductShop.Dtos.Export
{
    using ProductShop.Models;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlRoot("Users")]
    public class UserStartExportDto
    {
        [XmlElement("count")]
        public int CountUsers { get; set; }

        [XmlArray("users")]
        public List<UserProductExportDto> Users { get; set; }
    }
}
