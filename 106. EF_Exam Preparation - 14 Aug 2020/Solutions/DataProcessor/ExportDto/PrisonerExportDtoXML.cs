namespace SoftJail.DataProcessor.ExportDto
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Xml.Serialization;

    [XmlType("Prisoner")]
    public class PrisonerExportDtoXML
    {
        [XmlElement("Id")]
        public int Id { get; set; }

        [XmlElement("Name")]
        public string Name { get; set; }

        [XmlElement("IncarcerationDate")]
        public string IncarcerationDate { get; set; }

        [XmlArray("EncryptedMessages")]
        public List<MailDtoXML> MailMessages { get; set; }
    }

    [XmlType("Message")]
    public class MailDtoXML
    {
        [XmlElement("Description")]
        public string Description { get; set; }
    }
}
