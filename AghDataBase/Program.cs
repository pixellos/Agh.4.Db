using Bogus;
using System.Collections.Generic;
using System.Linq;

namespace AghDataBase
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var context = new Model1Container();
            var availableBuildings = PopulateBuildings();
            var randomizeIndividualClient = PopulateIndividualClient(availableBuildings);
            var randomizeCorporateClient = PopulateCorporateClient(availableBuildings);
            var randomizeConferences = PopulateConferences(availableBuildings, randomizeCorporateClient);

            context.IndividualClients.AddRange(randomizeIndividualClient);
            context.CorporateClients.AddRange(randomizeCorporateClient);
            context.Conferences.AddRange(randomizeConferences);

            context.SaveChanges();
        }

        private static List<Conference> PopulateConferences(List<Building> buildings, List<CorporateClient> corporateClients)
        {
            var conferenceDayFaker = new Faker<ConferenceDay>();
            conferenceDayFaker.RuleFor(x => x.Capacity, x => x.Random.Number(100));

            var conferenceFaker = new Faker<Conference>();
            conferenceFaker
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)])
                .RuleFor(x => x.Name, f => f.Lorem.Word())
                .RuleFor(x => x.StudentDiscount, f => (byte)f.Random.Number(99))
                .RuleFor(x => x.ConferenceDays, f => new[] { conferenceDayFaker.Generate() })
                .RuleFor(x => x.CorporateClient, f => corporateClients[f.Random.Number(corporateClients.Count - 1)]);

            return conferenceFaker.GenerateLazy(8).ToList();
        }

        private static List<CorporateClient> PopulateCorporateClient(List<Building> buildings)
        {
            var clientFaker = new Faker<Client>()
                .RuleFor(x => x.Telephone, f => f.Person.Phone)
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)]);

            var conferenceDay = new Faker<ConferenceDay>()
                .RuleFor(x => x.Date, f => f.Date.Future());

            var peselGenerator = new PeselGenerator();

            var icFaker = new Faker<CorporateClient>()
                .RuleFor(x => x.CompanyName, f => f.Company.CompanyName())
                .RuleFor(x => x.TaxNumber, f => f.Finance.Iban())
                .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(3).ToList();
        }

        private static List<IndividualClient> PopulateIndividualClient(List<Building> buildings)
        {
            var clientFaker = new Faker<Client>()
                .RuleFor(x => x.Telephone, f => f.Person.Phone)
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)]);

            var peselGenerator = new PeselGenerator();

            var icFaker = new Faker<IndividualClient>();
            icFaker.RuleFor(x => x.FirstName, f => f.Name.FirstName())
            .RuleFor(x => x.LastName, f => f.Name.LastName())
            .RuleFor(x => x.PersonalNumber, f => peselGenerator.Generate())
            .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(3).ToList();
        }

        private static List<Building> PopulateBuildings()
        {
            var availableBuildings = new List<Building>();

            var countryFaker = new Faker<Country>()
                .RuleFor(o => o.Name, f => f.Address.Country());

            var cityFaker = new Faker<City>()
                .RuleFor(o => o.Name, f => f.Address.City());

            var streetFaker = new Faker<Street>()
                .RuleFor(o => o.ZipCode, f => f.Address.ZipCode())
                .RuleFor(o => o.Name, f => f.Address.StreetName());

            var buildingFaker = new Faker<Building>()
                .RuleFor(o => o.ApartmentNumber, f => f.Random.Number(100))
                .RuleFor(o => o.Number, f => f.Address.BuildingNumber());

            var countries = countryFaker.Generate(3);

            foreach (var country in countries)
            {
                foreach (var cf in cityFaker.Generate(3))
                {
                    cf.Country = country;
                    foreach (var sf in streetFaker.Generate(4))
                    {
                        sf.City = cf;
                        foreach (var bf in buildingFaker.Generate(4))
                        {
                            bf.Street = sf;
                            availableBuildings.Add(bf);
                        }
                    }
                }
            }
            return availableBuildings;
        }
    }
}