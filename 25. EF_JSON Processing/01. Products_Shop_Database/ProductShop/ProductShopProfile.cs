namespace ProductShop
{
    using AutoMapper;
    using System.Linq;
    using ProductShop.DataTransferObjects;
    using ProductShop.Models;

    public class ProductShopProfile : Profile
    {
        public ProductShopProfile()
        {
            CreateMap<UserInputModel, User>();
            CreateMap<ProductInputModel, Product>();
            CreateMap<CategoryInputModel, Category>();
            CreateMap<CategoryProductInputModel, CategoryProduct>();

            CreateMap<Product, ProductsOutputInRange>()
                .ForMember(x => x.seller, y =>
                    y.MapFrom(z => string.Join(" ", z.Seller.FirstName, z.Seller.LastName)));
        }
    }
}
