using Bogus;
using System.Collections.Generic;
using System.Linq;

namespace AghDataBase
{
    internal class Program
    {
        private static PeselGenerator peselGenerator = new PeselGenerator();


        private static void Main(string[] args)
        {
            var context = new Model1Container();
            var availableBuildings = PopulateBuildings();
            var randomizeIndividualClient = PopulateIndividualClient(availableBuildings);
            var randomizeCorporateClient = PopulateCorporateClient(availableBuildings);
            var students = PopulateStudents(availableBuildings);
            var randomizeConferences = PopulateConferences(availableBuildings, randomizeCorporateClient, students, randomizeIndividualClient);

            var employeRelation = new Faker<CorporateClientEmploye>().RuleFor(x => x.Title, f => f.Company.CatchPhrase())
                .RuleFor(x => x.CorporateClient, f => f.PickRandom(randomizeCorporateClient))
                .RuleFor(x => x.IndividualClients, f => f.PickRandom(randomizeIndividualClient));

            context.IndividualClients.AddRange(randomizeIndividualClient);
            context.CorporateClients.AddRange(randomizeCorporateClient);
            context.Conferences.AddRange(randomizeConferences);
            context.Students.AddRange(students);
            context.CorporateClientEmployes.AddRange(employeRelation.GenerateLazy(700));
            context.SaveChanges();

            var faker = new Faker();
            var conferences = context.Conferences.ToArray();
            foreach (var conference in conferences)
            {
                var prices = faker.Random.Number(5);
                var tillDays = 0;
                var price = 0;

                for (var p = 0; p < prices; p++)
                {
                    tillDays += faker.Random.Number(1, 14);
                    var priceAddition = faker.Random.Number(1, 200);
                    price += priceAddition;
                    var toAdd = new ConferencePrices
                    {
                        TillConferenceStart = (short)tillDays,
                        Price = price
                    };
                    conference.ConferencePrices.Add(toAdd);
                }
            }
            context.SaveChanges();

            foreach (var conference in context.Conferences)
            {
                foreach (var day in conference.ConferenceDays)
                {
                    foreach (var reservation in day.Reservations)
                    {
                        if(faker.Random.Bool() && conference.ConferencePrices.Any())
                        {
                            var price = faker.PickRandom(conference.ConferencePrices);
                            reservation.ReservationPayment = new ReservationPayment()
                            {
                                Client = reservation.Client,
                                Amount = price.Price,
                                ConferencePrice = price,
                            };
                        }
                    }
                }
            }

            var workshops = context.Workshops.ToArray();
            foreach (var workshop in workshops)
            {
                var prices = faker.Random.Number(500);

                if (faker.Random.Bool())
                {
                    var toAdd = new WorkshopPrice
                    {
                        Price = faker.Random.Number(1, 400),
                    };
                    workshop.WorkshopPrice = toAdd;

                    foreach (var res in workshop.WorkshopReservations)
                    {
                        res.WorkshopReservationPayment = new WorkshopReservationPayment
                        {
                            Amount = workshop.WorkshopPrice.Price,
                        };
                    }
                }
            }
            context.SaveChanges();


        }

        private static List<Conference> PopulateConferences(List<Building> buildings, List<CorporateClient> corporateClients, IEnumerable<Student> clients, IEnumerable<IndividualClient> individualClients)
        {
            var conferenceDayFaker = new Faker<ConferenceDay>();
            conferenceDayFaker.RuleFor(x => x.Capacity, x => x.Random.Number(100));

            var workshopFaker = new Faker<Workshop>()
                .RuleFor(x => x.Name, f => new string(f.Hacker.Verb().Take(48).ToArray()))
                .RuleFor(x => x.WorkshopPrice, f => f.Random.Bool() ? new WorkshopPrice() { Price = (int)f.Random.Decimal(800) } : null);

            var cls = individualClients.Concat(clients.Select(x => x.IndividualClient)).Select(x => x.Client).ToList();

            var conferenceFaker = new Faker<Conference>();
            conferenceFaker
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)])
                .RuleFor(x => x.Name, f => f.Lorem.Word())
                .RuleFor(x => x.StudentDiscount, f => (byte)f.Random.Number(99))
                .RuleFor(x => x.ConferenceDays, f =>
                {

                    var list = new List<ConferenceDay>();
                    var r = f.Random.Number(1, 5);
                    var r2 = f.Random.Number(0, 3);
                    for (var i = 0; i < r; i++)
                    {
                        var date = f.Date.PastOffset(3);
                        var day = conferenceDayFaker.Generate();
                        for (var res = 0; res < f.Random.Number(day.Capacity); res++)
                        {
                            var reservation = new Reservation();
                            reservation.Client = f.PickRandom(cls);
                            day.Reservations.Add(reservation);
                        }

                        var randomDate = f.Date.RecentOffset(r, date);
                        day.Date = randomDate.Date;
                        if (list.All(x => x.Date != day.Date))
                        {
                            for (var w = 0; w < r2; w++)
                            {
                                var workshop = workshopFaker.Generate();
                                workshop.StartTime = f.Date.Between(day.Date, day.Date.AddDays(1));
                                workshop.EndTime = f.Date.Between(workshop.StartTime, day.Date.AddDays(1));
                                day.Workshops.Add(workshop);

                                var r3 = f.Random.Int(0, 7);
                                for (var rr3 = 0; rr3 < r3; rr3++)
                                {
                                    workshop.WorkshopReservations.Add(new WorkshopReservation
                                    {
                                        Client = f.PickRandom(cls)
                                    });
                                }
                            }

                            list.Add(day);
                        }
                    }
                    return list;
                })
                .RuleFor(x => x.CorporateClient, f => corporateClients[f.Random.Number(corporateClients.Count - 1)]);

            return conferenceFaker.GenerateLazy(2 * 3 * 12 + 5).ToList();
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
                .RuleFor(x => x.TaxNumber, f => f.Finance.Account(29))
                .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(40).ToList();
        }

        private static List<IndividualClient> PopulateIndividualClient(List<Building> buildings)
        {
            var clientFaker = new Faker<Client>()
                .RuleFor(x => x.Telephone, f => f.Person.Phone)
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)]);


            var icFaker = new Faker<IndividualClient>();
            icFaker.RuleFor(x => x.FirstName, f => f.Name.FirstName())
            .RuleFor(x => x.LastName, f => f.Name.LastName())
            .RuleFor(x => x.PersonalNumber, f => peselGenerator.Generate())
            .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(100).ToList();
        }

        private static List<Student> PopulateStudents(List<Building> buildings)
        {
            var studentFaker = new Faker<Student>();
            studentFaker
                .RuleFor(x => x.StudentId, f => new string(f.Random.Chars('0', '9', 9)))
                .RuleFor(x => x.IndividualClient, f => PopulateIndividualClient(buildings).First());
            return studentFaker.GenerateLazy(500).ToList();
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

            var countries = countryFaker.Generate(4);

            foreach (var country in countries)
            {
                foreach (var cf in cityFaker.Generate(8))
                {
                    cf.Country = country;
                    foreach (var sf in streetFaker.Generate(5))
                    {
                        sf.City = cf;
                        foreach (var bf in buildingFaker.Generate(2))
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