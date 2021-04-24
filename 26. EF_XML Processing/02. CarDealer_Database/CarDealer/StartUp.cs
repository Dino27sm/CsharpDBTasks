namespace CarDealer
{
    using CarDealer.Data;
    using CarDealer.DtoModels.InputDto;
    using CarDealer.DtoModels.OutputDto;
    using CarDealer.Models;
    using Microsoft.EntityFrameworkCore;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Xml.Serialization;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            var db = new CarDealerContext();
            //db.Database.EnsureDeleted();
            //db.Database.EnsureCreated();

            //var xmlSuppliers = File.ReadAllText("../../../Datasets/suppliers.xml");
            //var suppliersOut = ImportSuppliers(db, xmlSuppliers);

            //var xmlParts = File.ReadAllText("../../../Datasets/parts.xml");
            //var partsOut = ImportParts(db, xmlParts);

            //var xmlCars = File.ReadAllText("../../../Datasets/cars.xml");
            //var carsOut = ImportCars(db, xmlCars);

            //var xmlCustomers = File.ReadAllText("../../../Datasets/customers.xml");
            //var customersOut = ImportCustomers(db, xmlCustomers);

            //var xmlSales = File.ReadAllText("../../../Datasets/sales.xml");
            //var salesOut = ImportSales(db, xmlSales);

            string salesWithDiscount = GetSalesWithAppliedDiscount(db);
            Console.WriteLine(salesWithDiscount);

        }
        
        //======================= T19 ==================================================

        public static string GetSalesWithAppliedDiscount(CarDealerContext context)
        {
            var salesDiscountDto = context.Sales
            .Select(s => new SaleDiscountOutputDto()
            {
                CarDto = new CarDiscountOutputDto()
                {
                    Make = s.Car.Make,
                    Model = s.Car.Model,
                    TravelledDistance = s.Car.TravelledDistance
                },
                Discount = s.Discount,
                CustomerName = s.Customer.Name,
                Price = s.Car.PartCars.Sum(x => x.Part.Price),
                PriceWithDiscount = s.Car.PartCars.Sum(pc => pc.Part.Price) 
                    - s.Car.PartCars.Sum(pc => pc.Part.Price) * s.Discount / 100,
                })
            .ToList();

            var serializerXml = new XmlSerializer(typeof(List<SaleDiscountOutputDto>),
                                                        new XmlRootAttribute("sales"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, salesDiscountDto, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T18 ==================================================

        public static string GetTotalSalesByCustomer(CarDealerContext context)
        {
            var customerSales = context.Sales
                .Where(s => s.Customer.Sales.Count > 0)
                .Select(s => new CustomerSalesOutputDto
                {
                    FullName = s.Customer.Name,
                    BoughtCars = s.Customer.Sales.Count,
                    SpentMoney = s.Car.PartCars.Sum(x => x.Part.Price)
                })
                .OrderByDescending(x => x.SpentMoney)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<CustomerSalesOutputDto>), 
                new XmlRootAttribute("customers"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, customerSales, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T17 ==================================================

        public static string GetCarsWithTheirListOfParts(CarDealerContext context)
        {
            var carsWithParts = context.Cars
                .OrderByDescending(cp => cp.TravelledDistance)
                .ThenBy(cp => cp.Model)
                .Select(cp => new CarListOutputDto
                {
                    Make = cp.Make,
                    Model = cp.Model,
                    TravelledDistance = cp.TravelledDistance.ToString(),
                    PartCars = cp.PartCars.Select(x => new PartOutputDto
                    {
                        Name = x.Part.Name,
                        Price = x.Part.Price
                    })
                    .OrderByDescending(y => y.Price)
                    .ToList()
                }).Take(5).ToList();

            var serializerXml = new XmlSerializer(typeof(List<CarListOutputDto>), new XmlRootAttribute("cars"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, carsWithParts, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T16 ==================================================

        public static string GetLocalSuppliers(CarDealerContext context)
        {
            var suppliersInfo = context.Suppliers
                .Where(s => s.IsImporter == false)
                .Select(s => new SupplierOutputDto
                {
                    Id = s.Id.ToString(),
                    Name = s.Name,
                    Parts = s.Parts.Count.ToString()
                })
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<SupplierOutputDto>), new XmlRootAttribute("suppliers"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, suppliersInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T15 ==================================================

        public static string GetCarsFromMakeBmw(CarDealerContext context)
        {
            var bmwInfo = context.Cars
                .Where(b => b.Make == "BMW")
                .OrderBy(b => b.Model)
                .ThenByDescending(b => b.TravelledDistance)
                .Select(b => new CarBmwOutputDto
                {
                    Id = b.Id,
                    Model = b.Model,
                    TravelledDistance = b.TravelledDistance.ToString()
                })
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<CarBmwOutputDto>), new XmlRootAttribute("cars"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, bmwInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T14 ==================================================

        public static string GetCarsWithDistance(CarDealerContext context)
        {
            var carsInfo = context.Cars
                .Where(c => c.TravelledDistance > 2000000)
                .Select(c => new CarOutputDto 
                {
                    Make = c.Make,
                    Model = c.Model,
                    TravelledDistance = c.TravelledDistance
                })
                .OrderBy(s => s.Make)
                .ThenBy(s => s.Model)
                .Take(10)
                .ToList();

            var serializerXml = new XmlSerializer(typeof(List<CarOutputDto>), new XmlRootAttribute("cars"));
            var xmlResult = new StringWriter();
            var nameSpaces = new XmlSerializerNamespaces();
            nameSpaces.Add("", "");
            serializerXml.Serialize(xmlResult, carsInfo, nameSpaces);

            return xmlResult.ToString().Trim();
        }

        //======================= T13 ==================================================

        public static string ImportSales(CarDealerContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(SaleInputDto[]),
                new XmlRootAttribute("Sales"));
            var deserializedSales = (ICollection<SaleInputDto>)serializer
                .Deserialize(new StringReader(inputXml));

            var existingCarIds = context.Cars.Select(c => c.Id).ToList();

            var sales = deserializedSales
                .Where(c => existingCarIds.Contains(c.CarId))
                .Select(c => new Sale
                {
                    CarId = c.CarId,
                    CustomerId = c.CustomerId,
                    Discount = c.Discount
                }).ToList();

            context.Sales.AddRange(sales);
            context.SaveChanges();

            return $"Successfully imported {sales.Count}";
        }

        //======================= T12 ==================================================

        public static string ImportCustomers(CarDealerContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(CustomerInputDto[]), 
                new XmlRootAttribute("Customers"));
            var deserializedCustomers = (ICollection<CustomerInputDto>)serializer
                .Deserialize(new StringReader(inputXml));

            var customers = deserializedCustomers
                .Select(c => new Customer
                {
                    Name = c.Name,
                    BirthDate = c.BirthDate,
                    IsYoungDriver = c.IsYoungDriver
                }).ToList();

            context.Customers.AddRange(customers);
            context.SaveChanges();

            return $"Successfully imported {customers.Count}";
        }

        //======================= T11 ==================================================

        public static string ImportCars(CarDealerContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(CarInputDto[]), new XmlRootAttribute("Cars"));
            var deserializedCars = (ICollection<CarInputDto>)serializer.Deserialize(new StringReader(inputXml));

            var partIds = context.Parts.Select(p => p.Id).ToList();
            List<Car> cars = new List<Car>();
            foreach (var carDto in deserializedCars)
            {
                Car currentCar = new Car
                {
                    Make = carDto.Make,
                    Model = carDto.Model,
                    TravelledDistance = carDto.TravelledDistance,
                };
                foreach (var partDtoId in carDto.Parts.Select(x => x.Id).Distinct())
                {
                    if (partIds.Contains(partDtoId))
                    {
                        currentCar.PartCars.Add(new PartCar
                        {
                            PartId = partDtoId
                        });
                    }
                }
                cars.Add(currentCar);
            }

            context.Cars.AddRange(cars);
            context.SaveChanges();

            return $"Successfully imported {cars.Count}";
        }

        //======================= T10 ==================================================

        public static string ImportParts(CarDealerContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(PartInputDto[]), 
                new XmlRootAttribute("Parts"));
            var deserializedParts = (ICollection<PartInputDto>)serializer
                .Deserialize(new StringReader(inputXml));

            var suppliersId = context.Suppliers.Select(s => s.Id).ToList();
            var parts = deserializedParts
                .Where(p => suppliersId.Contains(p.SupplierId))
                .Select(p => new Part
                {
                    Name = p.Name,
                    Price = p.Price,
                    Quantity = p.Quantity,
                    SupplierId = p.SupplierId
                })
                .ToList();

            context.Parts.AddRange(parts);
            context.SaveChanges();

            return $"Successfully imported {parts.Count}";
        }

        //======================= T09 ==================================================

        public static string ImportSuppliers(CarDealerContext context, string inputXml)
        {
            var serializer = new XmlSerializer(typeof(SupplierInputDto[]), 
                new XmlRootAttribute("Suppliers"));
            var deserializedSuppliers = (ICollection<SupplierInputDto>)serializer
                .Deserialize(new StringReader(inputXml));

            var suppliers = deserializedSuppliers
                .Select(s => new Supplier
                {
                    Name = s.Name,
                    IsImporter = s.IsImporter
                })
                .ToList();

            context.Suppliers.AddRange(suppliers);
            context.SaveChanges();

            return $"Successfully imported {suppliers.Count}";
        }
    }
}