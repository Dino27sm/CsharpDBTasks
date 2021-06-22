using BookShop.Data.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace BookShop.DataProcessor.ImportDto
{
    public class ImportAuthorDtoJSON
    {
        [Required]
        [StringLength(30, MinimumLength = 3)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(30, MinimumLength = 3)]
        public string LastName { get; set; }

        [Required]
        [RegularExpression(@"\b\d{3}-\d{3}-\d{4}\b")]
        public string Phone { get; set; }

        [Required]
        [DataType(DataType.EmailAddress)]
        [EmailAddress]
        public string Email { get; set; }

        public List<BookAuthorDto> Books { get; set; }
    }

    public class BookAuthorDto 
    { 
        public int? Id { get; set; } 
    }
}
//•	Id - integer, Primary Key
//•	FirstName - text with length [3, 30]. (required)
//•	LastName - text with length[3, 30]. (required)
//•	Email - text(required).Validate it! There is attribute for this job.
//•	Phone - text.Consists only of three groups(separated by '-'),
//          the first two consist of three digits and the last one - of 4 digits. (required)
//•	AuthorsBooks - collection of type AuthorBook