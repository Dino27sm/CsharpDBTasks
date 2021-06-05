namespace VaporStore.DataProcessor
{
	using System;
	using System.Linq;
	using System.Globalization;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Text;
    using Data;
    using Newtonsoft.Json;
    using VaporStore.Data.Models;
    using VaporStore.DataProcessor.Dto.Import;

    public static class Deserializer
	{
		public static string ImportGames(VaporStoreDbContext context, string jsonString)
		{
			var gamesDto = JsonConvert.DeserializeObject<List<ImportGameDtoJSON>>(jsonString);

			StringBuilder sb = new StringBuilder();

            foreach (var gameItem in gamesDto)
            {
				if (!IsValid(gameItem) || gameItem.Tags.Count == 0)
                {
					sb.AppendLine("Invalid Data");
					continue;
                }

				DateTime releaseDateOK;
				bool isDateValid = DateTime.TryParseExact(gameItem.ReleaseDate, "yyyy-MM-dd",
					CultureInfo.InvariantCulture, DateTimeStyles.None, out releaseDateOK);

				var developer = context.Developers.FirstOrDefault(d => d.Name == gameItem.Developer);
				var genre = context.Genres.FirstOrDefault(g => g.Name == gameItem.Genre);

				if (developer == null)
					developer = new Developer() { Name = gameItem.Developer };

				if(genre == null)
					genre = new Genre() { Name = gameItem.Genre };

				Game game = new Game()
				{
					Name = gameItem.Name,
					Price = gameItem.Price,
					ReleaseDate = releaseDateOK,
					Developer = developer,
					Genre = genre
				};
                foreach (var tagItem in gameItem.Tags)
                {
					var getTag = context.Tags.FirstOrDefault(x => x.Name == tagItem);
					if(getTag == null)
                    {
						getTag = new Tag() { Name = tagItem };
                    }
					GameTag gameTag = new GameTag() { Tag = getTag };
					game.GameTags.Add(gameTag);
                }

				context.Games.Add(game);
				context.SaveChanges();
				sb.AppendLine($"Added {game.Name} ({game.Genre.Name}) with {game.GameTags.Count} tags");
			}

			return sb.ToString().Trim();
		}

		public static string ImportUsers(VaporStoreDbContext context, string jsonString)
		{
			return "TODO";
		}

		public static string ImportPurchases(VaporStoreDbContext context, string xmlString)
		{
			return "TODO";
		}

		private static bool IsValid(object dto)
		{
			var validationContext = new ValidationContext(dto);
			var validationResult = new List<ValidationResult>();

			return Validator.TryValidateObject(dto, validationContext, validationResult, true);
		}
	}
}