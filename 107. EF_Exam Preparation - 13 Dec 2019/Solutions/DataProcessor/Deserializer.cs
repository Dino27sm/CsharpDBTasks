namespace BookShop.DataProcessor
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml.Serialization;
    using BookShop.Data.Models;
    using BookShop.Data.Models.Enums;
    using BookShop.DataProcessor.ImportDto;
    using Data;
    using Newtonsoft.Json;
    using ValidationContext = System.ComponentModel.DataAnnotations.ValidationContext;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedBook
            = "Successfully imported book {0} for {1:F2}.";

        private const string SuccessfullyImportedAuthor
            = "Successfully imported author - {0} with {1} books.";

        public static string ImportBooks(BookShopContext context, string xmlString)
        {
            var serializer = new XmlSerializer(typeof(ImportBookDtoXML[]), new XmlRootAttribute("Books"));
            var deserializedBooks = (ICollection<ImportBookDtoXML>)
                        serializer.Deserialize(new StringReader(xmlString));

            StringBuilder sb = new StringBuilder();
            List<Book> books = new List<Book>();

            foreach (var bookItem in deserializedBooks)
            {
                if (!IsValid(bookItem))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                bool isValidDate = DateTime.TryParseExact(bookItem.PublishedOn, "MM/dd/yyyy", 
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime publishedDate);

                if (!isValidDate)
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Book book = new Book()
                {
                    Name = bookItem.Name,
                    Genre = Enum.Parse<Genre>(bookItem.Genre),
                    Price = bookItem.Price,
                    Pages = bookItem.Pages,
                    PublishedOn = publishedDate
                };
                books.Add(book);
                sb.AppendLine($"Successfully imported book {book.Name} for {book.Price:F2}.");
            }

            context.Books.AddRange(books);
            context.SaveChanges();

            return sb.ToString().Trim();
        }

        public static string ImportAuthors(BookShopContext context, string jsonString)
        {
            var authorsDto = JsonConvert.DeserializeObject<ICollection<ImportAuthorDtoJSON>>(jsonString);

            StringBuilder sb = new StringBuilder();
            List<int> booksId = context.Books.Select(x => x.Id).ToList();

            foreach (var authorItem in authorsDto)
            {
                if (!IsValid(authorItem))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                if(context.Authors.Any(x => x.Email == authorItem.Email))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                Author author = new Author()
                {
                    FirstName = authorItem.FirstName,
                    LastName = authorItem.LastName,
                    Phone = authorItem.Phone,
                    Email = authorItem.Email,
                };

                foreach (var bookItem in authorItem.Books)
                {
                    Book getBook = context.Books.FirstOrDefault(x => x.Id == bookItem.Id);
                    if(getBook == null)
                        continue;

                    AuthorBook authorBook = new AuthorBook()
                    {
                        AuthorId = author.Id,
                        BookId = getBook.Id
                    };
                    author.AuthorsBooks.Add(authorBook);
                }

                if(!author.AuthorsBooks.Any())
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }
                context.Authors.Add(author);
                context.SaveChanges();
                sb.AppendLine($"Successfully imported author - " +
                    $"{string.Join(" ", author.FirstName, author.LastName)} " +
                    $"with {author.AuthorsBooks.Count} books.");
            }
            return sb.ToString().Trim();
        }

        private static bool IsValid(object dto)
        {
            var validationContext = new ValidationContext(dto);
            var validationResult = new List<ValidationResult>();

            return Validator.TryValidateObject(dto, validationContext, validationResult, true);
        }
    }
}