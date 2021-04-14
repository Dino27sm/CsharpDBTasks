using ProductShop.Data;
using ProductShop.Dtos.Import;
using ProductShop.Models;
using System.Collections.Generic;
using System;
using System.IO;
using System.Linq;
using System.Xml.Serialization;
using ProductShop.Dtos.Export;
using Microsoft.EntityFrameworkCore;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main(string[] args)
        {
            var db = new ProductShopContext();
            //db.Database.EnsureDeleted();
            //db.Database.EnsureCreated();

            //string usersXml = File.ReadAllText("../../../Datasets/users.xml");
            //Console.WriteLine(ImportUsers(db, usersXml));

            //string productsXml = File.ReadAllText("../../../Datasets/products.xml");
            //Console.WriteLine(ImportProducts(db, productsXml));

            //string categoriesXml = File.ReadAllText("../../../Datasets/categories.xml");
            //Console.WriteLine(ImportCategories(db, categoriesXml));

            //string categorProductsXml = File.ReadAllText("../../../Datasets/categories-products.xml");
            //Console.WriteLine(ImportCategoryProducts(db, categorProductsXml));

            //====================== Here Ends Data Importing ==================================

            var usersWithProducts = GetUsersWithProducts(db);

            Console.WriteLine(usersWithProducts);

        }

        //====================== T08 ================================================

        public static string GetUsersWithProducts(ProductShopContext context)
        {
            var userProductsInfo = context.Users
                .Include(x => x.ProductsSold)
                .ToList()
                .Where(u => u.ProductsSold.Count >= 1)
                .Select(u => new UserProductExportDto()
                {
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    Age = u.Age,
                    ProductsSold = new SoldProductDto()
                    {
                        Count = u.ProductsSold.Count,
                        Products = u.ProductsSold.Select(x => new ProductExportDto
                        {
                            Name = x.Name,
                            Price = x.Price
                        })
                        .OrderByDescending(p => p.Price)
                        .ToList()
                    }
                })
                .OrderByDescending(s => s.ProductsSold.Count)
                .Take(10)
                .ToList();

            var finalResult = new UserStartExportDto()
            {
                CountUsers = context.Users.Count(x => x.ProductsSold.Count >= 1),
                Users = userProductsInfo.ToList()
            };

            var serializerXml = new XmlSerializer(typeof(UserStartExportDto),
                                    new XmlRootAttribute("Users"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, finalResult, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //====================== T07 ================================================

        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var categoryInfo = context.Categories
                .Select(c => new CategoryExportDto()
                {
                    Name = c.Name,
                    Count = c.CategoryProducts.Count,
                    AveragePrice = c.CategoryProducts.Average(x => x.Product.Price),
                    TotalRevenue = c.CategoryProducts.Sum(x => x.Product.Price)
                })
                .OrderByDescending(s => s.Count)
                .ThenBy(s => s.TotalRevenue)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<CategoryExportDto>),
                                    new XmlRootAttribute("Categories"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, categoryInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //====================== T06 ================================================

        public static string GetSoldProducts(ProductShopContext context)
        {
            var usersInfo = context.Users
                .Where(u => u.ProductsSold.Count > 0)
                .Select(u => new UserExportDto()
                {
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    ProductsSold = u.ProductsSold.Select(p => new ProductExportDto()
                    {
                        Name = p.Name,
                        Price = p.Price
                    }).ToList()
                })
                .OrderBy(s => s.LastName)
                .ThenBy(s => s.FirstName)
                .Take(5)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<UserExportDto>),
                                    new XmlRootAttribute("Users"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, usersInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //====================== T05 ================================================

        public static string GetProductsInRange(ProductShopContext context)
        {
            var productsInfo = context.Products
                .Where(p => p.Price >= 500 && p.Price <= 1000)
                .Select(p => new ProductExportDto()
                {
                    Name = p.Name,
                    Price = p.Price,
                    BuyerFullName = string.Join(" ", p.Buyer.FirstName, p.Buyer.LastName)
                })
                .OrderBy(s => s.Price)
                .Take(10)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<ProductExportDto>), 
                                    new XmlRootAttribute("Products"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, productsInfo, nameSpaces);

            return xmlResult.ToString().Trim();

        }

        //====================== T04 ================================================

        public static string ImportCategoryProducts(ProductShopContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(CategoryProductImportDto[]), 
                                        new XmlRootAttribute("CategoryProducts"));
            var deserialCategoryProducts = (ICollection<CategoryProductImportDto>)serializer
                                        .Deserialize(new StringReader(inputXml));

            var categoryProducts = deserialCategoryProducts
                .Where(cp => cp.CategoryId != null && cp.ProductId != null)
                .Select(cp => new CategoryProduct()
                {
                    CategoryId = cp.CategoryId.Value,
                    ProductId = cp.ProductId.Value
                }).ToList();

            context.CategoryProducts.AddRange(categoryProducts);
            context.SaveChanges();

            return $"Successfully imported {categoryProducts.Count}";
        }

        //====================== T03 ================================================

        public static string ImportCategories(ProductShopContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(CategoryImportDto[]), new XmlRootAttribute("Categories"));
            var deserialCategories = (ICollection<CategoryImportDto>)serializer.Deserialize(new StringReader(inputXml));

            var categories = deserialCategories
                .Where(c => c.Name != null)
                .Select(c => new Category()
                {
                    Name = c.Name
                }).ToList();

            context.Categories.AddRange(categories);
            context.SaveChanges();

            return $"Successfully imported {categories.Count}";
        }

        //====================== T02 ================================================

        public static string ImportProducts(ProductShopContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(ProductImportDto[]), new XmlRootAttribute("Products"));
            var deserialProducts = (ICollection<ProductImportDto>)serializer.Deserialize(new StringReader(inputXml));

            var products = deserialProducts
                .Select(p => new Product()
                {
                    Name = p.Name,
                    Price = p.Price,
                    SellerId = p.SellerId,
                    BuyerId = p.BuyerId
                }).ToList();

            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Count}";
        }

        //====================== T01 ================================================

        public static string ImportUsers(ProductShopContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(UserImportDto[]), new XmlRootAttribute("Users"));
            var deserialUsers = (ICollection<UserImportDto>)serializer.Deserialize(new StringReader(inputXml));

            var users = deserialUsers
                .Select(u => new User()
                {
                    FirstName = u.FirstName,
                    LastName = u.LastName,
                    Age = u.Age
                }).ToList();

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Count}";
        }
    }
}