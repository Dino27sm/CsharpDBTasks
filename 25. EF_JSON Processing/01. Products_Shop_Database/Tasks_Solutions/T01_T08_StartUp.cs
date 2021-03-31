using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using ProductShop.Data;
using ProductShop.DataTransferObjects;
using ProductShop.Models;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main(string[] args)
        {
            var db = new ProductShopContext();
            //db.Database.EnsureDeleted();
            //db.Database.EnsureCreated();

            //var userFile = File.ReadAllText("../../../Datasets/users.json");
            //ImportUsers(db, userFile);

            //var productFile = File.ReadAllText("../../../Datasets/products.json");
            //ImportProducts(db, productFile);

            //var categoryFile = File.ReadAllText("../../../Datasets/categories.json");
            //ImportCategories(db, categoryFile);

            ////==================== T04 ===========================
            //var categoryProductFile = File.ReadAllText("../../../Datasets/categories-products.json");
            //var result = ImportCategoryProducts(db, categoryProductFile);

            var result = GetUsersWithProducts(db);
            Console.WriteLine(result);
        }

        //============================= T08 ==========================================

        public static string GetUsersWithProducts(ProductShopContext context)
        {
            var usersInfo = context.Users
                .Include(u => u.ProductsSold)
                .ToList()
                .Where(u => u.ProductsSold.Any(x => x.BuyerId != null))
                .Select(u => new
                {
                    firstName = u.FirstName,
                    lastName = u.LastName,
                    age = u.Age,
                    soldProducts = new
                    {
                        count = u.ProductsSold.Where(x => x.BuyerId != null).Count(),
                        products = u.ProductsSold.Where(p => p.BuyerId != null)
                            .Select(p => new
                            {
                                name = p.Name,
                                price = p.Price
                            })
                    }
                })
                .OrderByDescending(s => s.soldProducts.products.Count())
                .ToList();

            var outViaJson = new
            {
                usersCount = usersInfo.Count(),
                users = usersInfo
            };

            var settings = new JsonSerializerSettings()
            {
                NullValueHandling = NullValueHandling.Ignore,
                Formatting = Formatting.Indented
            };

            return JsonConvert.SerializeObject(outViaJson, settings);
        }

        //============================= T07 ==========================================

        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var categoriesInfo = context.Categories
                .Select(c => new
                {
                    category = c.Name,
                    productsCount = c.CategoryProducts.Count,
                    averagePrice = string.Format("{0:F2}", c.CategoryProducts.Average(x => x.Product.Price)),
                    totalRevenue = string.Format("{0:F2}", c.CategoryProducts.Sum(x => x.Product.Price))
                })
                .OrderByDescending(s => s.productsCount)
                .ToList();

            return JsonConvert.SerializeObject(categoriesInfo, Formatting.Indented);
        }

        //============================= T06 ==========================================

        public static string GetSoldProducts(ProductShopContext context)
        {
            var userInfo = context.Users
                .Where(u => u.ProductsSold.Any(x => x.BuyerId != null))
                .Select(u => new
                {
                    firstName = u.FirstName,
                    lastName = u.LastName,
                    soldProducts = u.ProductsSold.Select(p => new
                    {
                        name = p.Name,
                        price = p.Price,
                        buyerFirstName = p.Buyer.FirstName,
                        buyerLastName = p.Buyer.LastName
                    })
                })
                .OrderBy(s => s.lastName)
                .ThenBy(s => s.firstName)
                .ToList();

            return JsonConvert.SerializeObject(userInfo, Formatting.Indented);
        }

        //============================= T05 ==========================================

        public static string GetProductsInRange(ProductShopContext context)
        {
            var mappConfig = new MapperConfiguration(cfg => cfg.AddProfile<ProductShopProfile>());

            var productsInfo = context.Products
                .Where(p => p.Price >= 500 && p.Price <= 1000)
                .OrderBy(p => p.Price)
                .ProjectTo<ProductsOutputInRange>(mappConfig)
                .ToList();

            return JsonConvert.SerializeObject(productsInfo, Formatting.Indented);
        }

        //============================= T04 ==========================================

        public static string ImportCategoryProducts(ProductShopContext context, string inputJson)
        {
            var mappConfig = new MapperConfiguration(cfg => cfg.AddProfile<ProductShopProfile>());
            var mapper = mappConfig.CreateMapper();

            var categoryProductDto = JsonConvert.DeserializeObject<IEnumerable<CategoryProductInputModel>>(inputJson);
            var categoryProducts = mapper.Map<IEnumerable<CategoryProduct>>(categoryProductDto);

            context.CategoryProducts.AddRange(categoryProducts);
            context.SaveChanges();

            return $"Successfully imported {categoryProducts.Count()}";
        }

        //============================= T03 ==========================================

        public static string ImportCategories(ProductShopContext context, string inputJson)
        {
            var mappConfig = new MapperConfiguration(cfg => cfg.AddProfile<ProductShopProfile>());
            var mapper = mappConfig.CreateMapper();

            var categoriesDto = JsonConvert.DeserializeObject<IEnumerable<CategoryInputModel>>(inputJson);
            var categories = mapper.Map<IEnumerable<Category>>(categoriesDto);
            var categoriesNotNull = categories.Where(x => x.Name != null).ToList();

            context.Categories.AddRange(categoriesNotNull);
            context.SaveChanges();

            return $"Successfully imported {categoriesNotNull.Count()}";
        }

        //============================= T02 ==========================================

        public static string ImportProducts(ProductShopContext context, string inputJson)
        {
            var mappConfig = new MapperConfiguration(cfg => cfg.AddProfile<ProductShopProfile>());
            var mapper = mappConfig.CreateMapper();

            var productsDto = JsonConvert.DeserializeObject<IEnumerable<ProductInputModel>>(inputJson);
            var products = mapper.Map<IEnumerable<Product>>(productsDto);

            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Count()}";
        }

        //============================= T01 ==========================================

        public static string ImportUsers(ProductShopContext context, string inputJson)
        {
            var mappConfig = new MapperConfiguration(cfg => cfg.AddProfile<ProductShopProfile>());
            var mapper = mappConfig.CreateMapper();

            var usersDto = JsonConvert.DeserializeObject<IEnumerable<UserInputModel>>(inputJson);
            var users = mapper.Map<IEnumerable<User>>(usersDto);

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Count()}";
        }
    }
}