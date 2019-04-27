using System;
using System.Text;

namespace AghDataBase
{
    public class PeselGenerator
    {
        private readonly Random _random;

        public PeselGenerator()
        {
            this._random = new Random();
        }

        public string Generate()
        {
            var peselStringBuilder = new StringBuilder();
            var birthDate = this.GenerateDate(1900, 2099);

            this.AppendPeselDate(birthDate, peselStringBuilder);

            peselStringBuilder.Append(this.GenerateRandomNumbers(4));

            peselStringBuilder.Append(PeselCheckSumCalculator.Calculate(peselStringBuilder.ToString()));

            return peselStringBuilder.ToString();
        }

        public static string GetPeselMonthShiftedByYear(DateTime date)
        {
            if (date.Year < 1900 || date.Year > 2299)
            {
                throw new NotSupportedException(System.String.Format("PESEL for year: {0} is not supported", date.Year));
            }

            var monthShift = (int)((date.Year - 1900) / 100) * 20;

            return (date.Month + monthShift).ToString("00");
        }

        private DateTime GenerateDate(int yearFrom, int yearTo)
        {
            var year = this._random.Next(yearFrom, yearTo + 1);
            var month = this._random.Next(12) + 1;
            var day = this._random.Next(DateTime.DaysInMonth(year, month)) + 1;

            return new DateTime(year, month, day);
        }

        private void AppendPeselDate(DateTime date, StringBuilder builder)
        {
            builder.Append((date.Year % 100).ToString("00"));
            builder.Append(GetPeselMonthShiftedByYear(date));
            builder.Append(date.Day.ToString("00"));
        }

        private string GenerateRandomNumbers(int numbersCount)
        {
            var maxValue = (int)Math.Pow(10, numbersCount);
            var format = "D" + numbersCount;

            return this._random.Next(maxValue).ToString(format);
        }
    }
}