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
    
    public partial class ConferencePrices
    {
        public int Id { get; set; }
        public int ConferenceId { get; set; }
        public System.DateTimeOffset TillConferenceStart { get; set; }
        public string Price { get; set; }
    
        public virtual Conference Conference { get; set; }
    }
}
