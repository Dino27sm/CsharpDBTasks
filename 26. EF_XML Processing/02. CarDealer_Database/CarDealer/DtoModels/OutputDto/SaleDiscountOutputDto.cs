namespace CarDealer.DtoModels.OutputDto
{
    using System.Xml.Serialization;

    [XmlType("sale")]
    public class SaleDiscountOutputDto
    {
        [XmlElement("car")]
        public CarDiscountOutputDto CarDto { get; set; }

        [XmlElement("discount")]
        public decimal Discount { get; set; }

        [XmlElement("customer-name")]
        public string CustomerName { get; set; }

        [XmlElement("price")]
        public decimal Price { get; set; }

        [XmlElement("price-with-discount")]
        public decimal PriceWithDiscount { get; set; }
    }
}
