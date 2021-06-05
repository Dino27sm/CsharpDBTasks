namespace VaporStore.DataProcessor
{
	using System;
	using System.Globalization;
	using Newtonsoft.Json;
	using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using Data;
    using VaporStore.DataProcessor.Dto.Import;
    using System.Linq;
    using System.Text;
    using VaporStore.Data.Models;
    using System.Xml.Serialization;
    using System.IO;
    using VaporStore.Data.Models.Enums;

    public static class Deserializer
	{
		public static string ImportGames(VaporStoreDbContext context, string jsonString)
		{
			var gamesDto = JsonConvert.DeserializeObject<ICollection<ImportGameDtoJSON>>(jsonString);

			StringBuilder sb = new StringBuilder();

            foreach (var gameItem in gamesDto)
            {
				if (!IsValid(gameItem) || !gameItem.Tags.Any())
                {
					sb.AppendLine("Invalid Data");
					continue;
                }

				//var developer = context.Developers.FirstOrDefault(x => x.Name == gameItem.Developer) 
				//	?? new Developer() { Name = gameItem.Developer };
				var developer = context.Developers.FirstOrDefault(x => x.Name == gameItem.Developer);
				if(developer == null)
                {
					developer = new Developer() { Name = gameItem.Developer };
                }

				//var genre = context.Genres.FirstOrDefault(x => x.Name == gameItem.Genre) 
				//	?? new Genre() { Name = gameItem.Genre };
				var genre = context.Genres.FirstOrDefault(x => x.Name == gameItem.Genre);
				if (genre == null)
				{
					genre = new Genre() { Name = gameItem.Genre };
				}

				Game game = new Game()
				{
					Name = gameItem.Name,
					Price = gameItem.Price,
					ReleaseDate = gameItem.ReleaseDate.Value,
					Developer = developer,
					Genre = genre,
				};

                foreach (var tagItem in gameItem.Tags)
                {
					var tag = context.Tags.FirstOrDefault(t => t.Name == tagItem);
					if (tag == null)
                    {
						tag = new Tag() { Name = tagItem };
                    }
					game.GameTags.Add(new GameTag() { Tag = tag });
                }
				context.Games.Add(game);
				context.SaveChanges();
				sb.AppendLine($"Added {game.Name} ({game.Genre.Name}) with {game.GameTags.Count()} tags");
            }

			return sb.ToString().Trim();
		}

		public static string ImportUsers(VaporStoreDbContext context, string jsonString)
		{
			var usersDto = JsonConvert.DeserializeObject<ICollection<ImportUserCardDtoJSON>>(jsonString);

			StringBuilder sb = new StringBuilder();

            foreach (var userItem in usersDto)
            {
				if (!IsValid(userItem) || !userItem.Cards.All(x => IsValid(x)))
                {
					sb.AppendLine("Invalid Data");
					continue;
                }

				User user = new User()
				{
					FullName = userItem.FullName,
					Username = userItem.Username,
					Email = userItem.Email,
					Age = userItem.Age,
					Cards = userItem.Cards.Select(x => new Card()
					{
						Number = x.Number,
						Cvc = x.Cvc,
						Type = Enum.Parse<CardType>(x.Type)
					}).ToList()
				};
				context.Users.Add(user);
				context.SaveChanges();
				sb.AppendLine($"Imported {user.Username} with {user.Cards.Count} cards");
            }

			return sb.ToString().Trim();
		}

		public static string ImportPurchases(VaporStoreDbContext context, string xmlString)
		{
			var serializer = new XmlSerializer(typeof(List<ImportPurchaseDtoXML>), 
								new XmlRootAttribute("Purchases"));
			var purchasesDto = (ICollection<ImportPurchaseDtoXML>)
								serializer.Deserialize(new StringReader(xmlString));

			StringBuilder sb = new StringBuilder();

            foreach (var purchaseItem in purchasesDto)
            {
				if (!IsValid(purchaseItem))
                {
					sb.AppendLine("Invalid Data");
					continue;
                }

				var card = context.Cards.FirstOrDefault(x => x.Number == purchaseItem.CardNumber);
				var game = context.Games.FirstOrDefault(x => x.Name == purchaseItem.Title);

				Purchase purchase = new Purchase()
				{
					Game = game,
					Type = Enum.Parse<PurchaseType>(purchaseItem.Type),
                    ProductKey = purchaseItem.ProductKey,
					Card = card,
					Date = DateTime.ParseExact(purchaseItem.Date, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture)
				};
				context.Purchases.Add(purchase);
				context.SaveChanges();
				sb.AppendLine($"Imported {purchase.Game.Name} for {purchase.Card.User.Username}");
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