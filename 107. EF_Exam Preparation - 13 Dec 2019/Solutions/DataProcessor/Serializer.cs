namespace BookShop.DataProcessor
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml;
    using System.Xml.Serialization;
    using BookShop.Data.Models.Enums;
    using BookShop.DataProcessor.ExportDto;
    using Data;
    using Newtonsoft.Json;
    using Formatting = Newtonsoft.Json.Formatting;

    public class Serializer
    {
        public static string ExportMostCraziestAuthors(BookShopContext context)
        {
            var authorsInfo = context.Authors
                .Select(a => new
                {
                    AuthorName = string.Join(" ", a.FirstName, a.LastName),
                    Books = a.AuthorsBooks
                    .OrderByDescending(p => p.Book.Price)
                    .Select(b => new
                    {
                        BookName = b.Book.Name,
                        BookPrice = b.Book.Price.ToString("F2")
                    })
                    .ToList()
                })
                .ToList()
                .OrderByDescending(sa => sa.Books.Count())
                .ThenBy(sa => sa.AuthorName)
                .ToList();

            return JsonConvert.SerializeObject(authorsInfo, Formatting.Indented);
        }

        public static string ExportOldestBooks(BookShopContext context, DateTime date)
        {
            //DateTime dateTime = DateTime.ParseExact("25/01/2017", "dd/MM/yyyy", CultureInfo.InvariantCulture);

            var oldestBooksInfo = context.Books.ToList()
                .Where(b => b.PublishedOn < date && b.Genre.ToString() == "Science")
                .OrderByDescending(x => x.Pages)
                .ThenByDescending(x => x.PublishedOn)
                .Select(b => new ExportOldestBookDtoXML()
                {
                    BookPages = b.Pages.ToString(),
                    BookName = b.Name,
                    BookPublished = b.PublishedOn.ToString("d", CultureInfo.InvariantCulture)
                })
                .Take(10)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<ExportOldestBookDtoXML>), 
                                        new XmlRootAttribute("Books"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, oldestBooksInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }
    }
}