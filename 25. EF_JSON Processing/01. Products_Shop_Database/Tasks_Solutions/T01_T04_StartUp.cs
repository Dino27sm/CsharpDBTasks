using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using AutoMapper;
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
            db.Database.EnsureDeleted();
            db.Database.EnsureCreated();

            var userFile = File.ReadAllText("../../../Datasets/users.json");
            ImportUsers(db, userFile);

            var productFile = File.ReadAllText("../../../Datasets/products.json");
            ImportProducts(db, productFile);

            var categoryFile = File.ReadAllText("../../../Datasets/categories.json");
            ImportCategories(db, categoryFile);

            //==================== T04 ===========================
            var categoryProductFile = File.ReadAllText("../../../Datasets/categories-products.json");
            var result = ImportCategoryProducts(db, categoryProductFile);

            Console.WriteLine(result);
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