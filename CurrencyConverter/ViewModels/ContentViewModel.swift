//
//  ContentViewModel.swift
//  Currency Converter
//
//  Created by Shazan Zaidi on 05/11/25.
//

import Foundation
import SwiftUI


@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var baseAmount: Float64 = 1.0
    @Published var convertedAmount: Float64 = 1.0
    @Published var baseCurrency: CurrencyChoice = .Usa
    @Published var convertedCurrency: CurrencyChoice = .Indian
    @Published var rates: Rates?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showInfo = false
    @StateObject private var keyModel = KeyModel()
    
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        return numberFormatter
    }
    
    func fetchRates() async{
        guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(keyModel.app_id)") else {
            errorMessage = "Sorry, Could not Fetch Rates 😞"
            return
        }
        let urlRequest = URLRequest(url: url)
        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            rates = try JSONDecoder().decode(Rates.self, from: data)
             
        }
        catch {
            errorMessage = "Sorry, Could not Fetch Rates 😞"
            print(error.localizedDescription)
        }
        convert()
        isLoading = false
        
        
    }
    
    func swapCurrencies() {
        swap(&baseCurrency, &convertedCurrency)
        swap(&baseAmount, &convertedAmount)
    }
    
    func convert(){
        if let rates = rates,
            let baseRate = rates.rates[baseCurrency.rawValue],
           let convertedRate = rates.rates[convertedCurrency.rawValue]
        {
            convertedAmount = (baseAmount * convertedRate) / baseRate
        }
    }
    
}
