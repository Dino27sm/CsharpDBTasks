using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using VaporStore.Data.Models;

namespace VaporStore.DataProcessor.Dto.Import
{
    public class ImportUserCardDtoJSON
    {
        [Required]
        [RegularExpression(@"[A-Z][a-z]+\s[A-Z][a-z]+")]
        public string FullName { get; set; }

        [Required]
        [StringLength(20, MinimumLength = 3)]
        public string Username { get; set; }

        [Required]
        public string Email { get; set; }

        [Range(3, 103)]
        public int Age { get; set; }

        public List<ImportCardDtoJSON> Cards { get; set; }
    }

    public class ImportCardDtoJSON
    {
        [Required]
        [RegularExpression(@"(\d{4}\s){3}\d{4}")]
        public string Number { get; set; }

        [Required]
        [RegularExpression(@"\b\d{3}\b")]
        public string Cvc { get; set; }

        [EnumDataType(typeof(CardType))]
        public string Type { get; set; }
    }
}
