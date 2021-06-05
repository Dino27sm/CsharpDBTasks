namespace VaporStore.DataProcessor
{
	using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Serialization;
    using Data;
    using Newtonsoft.Json;
    using VaporStore.DataProcessor.Dto.Export;

    public static class Serializer
	{
		public static string ExportGamesByGenres(VaporStoreDbContext context, string[] genreNames)
		{
			var exportGamesGenres = context.Genres.ToList()
				.Where(g => genreNames.Contains(g.Name))
				.Select(g => new
				{
					Id = g.Id,
					Genre = g.Name,
					Games = g.Games.Select(x => new
					{
						Id = x.Id,
						Title = x.Name,
						Developer = x.Developer.Name,
						Tags = string.Join(", ", x.GameTags.Select(y => y.Tag.Name)),
						Players = x.Purchases.Count
					})
					.Where(gs => gs.Players > 0)
					.OrderByDescending(gs => gs.Players)
					.ThenBy(gs => gs.Id)
					.ToList(),
					TotalPlayers = g.Games.Sum(z => z.Purchases.Count())
				})
				.OrderByDescending(s => s.TotalPlayers)
				.ThenBy(s => s.Id);

            return JsonConvert.SerializeObject(exportGamesGenres, Newtonsoft.Json.Formatting.Indented);
		}

		public static string ExportUserPurchasesByType(VaporStoreDbContext context, string storeType)
		{
			var usersInfo = context.Users.ToList()
				.Where(x => x.Cards.Any(y => y.Purchases.Any(z => z.Type.ToString() == storeType)))
				.Select(x => new ExportUserDtoXML()
				{
					Username = x.Username,
					TotalSpent = x.Cards.Select(p => p.Purchases.Where(z => z.Type.ToString() == storeType))
						.Select(s => s.Sum(m => m.Game.Price)).Sum(),
					Purchases = x.Cards.SelectMany(y => y.Purchases)
					.Where(z => z.Type.ToString() == storeType)
					.Select(z => new CardDto()
                    {
						CardNumber = z.Card.Number,
						CvcNumber = z.Card.Cvc,
						Date = z.Date.ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture),
						Game = new GameDto()
                        {
							Title = z.Game.Name,
							GenreName = z.Game.Genre.Name,
							Price = z.Game.Price
                        }
                    })
					.OrderBy(c => c.Date)
					.ToList()

				})
				.OrderByDescending(d => d.TotalSpent)
				.ThenBy(d => d.Username)
				.ToList();

			var serializerXml = new XmlSerializer(typeof(List<ExportUserDtoXML>), new XmlRootAttribute("Users"));
			var xmlResult = new StringWriter();
			var nameSpaces = new XmlSerializerNamespaces();
			nameSpaces.Add("", "");
			serializerXml.Serialize(xmlResult, usersInfo, nameSpaces);

			return xmlResult.ToString().Trim();
		}
	}
}