//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace AghDataBase
{
    using System;
    using System.Collections.Generic;
    
    public partial class ConferenceDay
    {
        public int Id { get; set; }
        public string Date { get; set; }
        public int ConferenceId { get; set; }
        public int Capacity { get; set; }
    
        public virtual Conference Conference { get; set; }
    }
}