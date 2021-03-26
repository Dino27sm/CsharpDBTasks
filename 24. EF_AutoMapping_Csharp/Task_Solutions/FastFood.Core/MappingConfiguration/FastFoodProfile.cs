namespace FastFood.Core.MappingConfiguration
{
    using AutoMapper;
    using FastFood.Core.ViewModels.Categories;
    using FastFood.Models;
    using ViewModels.Positions;
    using ViewModels.Items;
    using FastFood.Core.ViewModels.Employees;
    using FastFood.Core.ViewModels.Orders;

    public class FastFoodProfile : Profile
    {
        public FastFoodProfile()
        {
            //Positions
            this.CreateMap<CreatePositionInputModel, Position>()
                .ForMember(x => x.Name, y => y.MapFrom(s => s.PositionName));

            this.CreateMap<Position, PositionsAllViewModel>()
                .ForMember(x => x.Name, y => y.MapFrom(s => s.Name));

            //Categories
            this.CreateMap<CreateCategoryInputModel, Category>()
                .ForMember(x => x.Name, y => y.MapFrom(z => z.CategoryName));

            this.CreateMap<Category, CategoryAllViewModel>();

            //Items
            this.CreateMap<CreateItemInputModel, Item>();
            this.CreateMap<Category, CreateItemViewModel>()
                .ForMember(x => x.CategoryId, y => y.MapFrom(z => z.Id));

            this.CreateMap<Item, ItemsAllViewModels>()
                .ForMember(x => x.Category, y => y.MapFrom(z => z.Category.Name));

            //Employees
            this.CreateMap<RegisterEmployeeInputModel, Employee>()
                .ForMember(x => x.Position, y => y.MapFrom(z => z.PositionName));
            this.CreateMap<Position, RegisterEmployeeViewModel>()
                .ForMember(x => x.PositionId, y => y.MapFrom(z => z.Id));

            this.CreateMap<Employee, EmployeesAllViewModel>()
                .ForMember(x => x.Position, y => y.MapFrom(z => z.Position.Name));

            //Orders
            this.CreateMap<CreateOrderInputModel, Order>();
                
            this.CreateMap<Order, CreateOrderViewModel>()
                .ForMember(x => x.Employees, y => y.MapFrom(z => z.Employee));

            this.CreateMap<Order, OrderAllViewModel>()
                .ForMember(x => x.DateTime, y => y.MapFrom(z => z.DateTime.ToString()))
                .ForMember(x => x.OrderId, y => y.MapFrom(z => z.Id));

        }
    }
}
