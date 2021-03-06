{"Report"=>
  {"Header"=>
    {"Time"=>"2016-04-26T15:39:24-07:00",
     "ReportName"=>"CashFlow",
     "DateMacro"=>"this calendar year-to-date",
     "StartPeriod"=>"2016-01-01",
     "EndPeriod"=>"2016-04-26",
     "SummarizeColumnsBy"=>"Total",
     "Currency"=>"USD",
     "Option"=>{"Name"=>"NoReportData", "Value"=>"false"}},
   "Columns"=>
    {"Column"=>[{"ColTitle"=>nil, "ColType"=>"Account"}, {"ColTitle"=>"Total", "ColType"=>"Money"}]},
   "Rows"=>
    {"Row"=>
      [{"type"=>"Section",
        "group"=>"OperatingActivities",
        "Header"=>{"ColData"=>[{"value"=>"OPERATING ACTIVITIES"}, {"value"=>""}]},
        "Rows"=>
         {"Row"=>
           [{"type"=>"Data",
             "group"=>"NetIncome",
             "ColData"=>[{"value"=>"Net Income"}, {"value"=>"1551.21"}]},
            {"type"=>"Section",
             "group"=>"OperatingAdjustments",
             "Header"=>
              {"ColData"=>
                [{"value"=>"Adjustments to reconcile Net Income to Net Cash provided by operations:"},
                 {"value"=>""}]},
             "Rows"=>
              {"Row"=>
                [{"type"=>"Data",
                  "ColData"=>
                   [{"value"=>"Accounts Receivable (A/R)", "id"=>"84"}, {"value"=>"-4879.77"}]},
                 {"type"=>"Data",
                  "ColData"=>[{"value"=>"Inventory Asset", "id"=>"81"}, {"value"=>"-596.25"}]},
                 {"type"=>"Data",
                  "ColData"=>[{"value"=>"Accounts Payable (A/P)", "id"=>"33"}, {"value"=>"1602.67"}]},
                 {"type"=>"Data",
                  "ColData"=>[{"value"=>"Mastercard", "id"=>"41"}, {"value"=>"157.72"}]},
                 {"type"=>"Data",
                  "ColData"=>
                   [{"value"=>"Arizona Dept. of Revenue Payable", "id"=>"89"}, {"value"=>"0.00"}]},
                 {"type"=>"Data",
                  "ColData"=>
                   [{"value"=>"Board of Equalization Payable", "id"=>"90"}, {"value"=>"360.44"}]},
                 {"type"=>"Data",
                  "ColData"=>[{"value"=>"Loan Payable", "id"=>"43"}, {"value"=>"4000.00"}]}]}}]},
        "Summary"=>
         {"ColData"=>
           [{"value"=>"Total Adjustments to reconcile Net Income to Net Cash provided by operations:"},
            {"value"=>"644.81"}]}},
       {"type"=>"Section",
        "group"=>"EndingCash",
        "Summary"=>{"ColData"=>[{"value"=>"Cash at end of period"}, {"value"=>"4063.52"}]}}]}}}