//
//  ContentView.swift
//  Currency Converter
//
//  Created by Shazan Zaidi on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @FocusState private var baseCurrencyIsFocused: Bool
    @FocusState private var convertedCurrencyIsFocused: Bool
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "info.circle.fill").font(.system(size: 25)).foregroundStyle(Color.black).onTapGesture {
                        viewModel.showInfo.toggle()
                    }
                    
                    if viewModel.showInfo {
                            VStack(alignment: .leading, spacing: 0) {
                                        Text("To Convert please tap the Convert Button!").padding()
                                Divider()
                                Text("Developed by Shazan Zaidi").opacity(0.5).padding()
                                    
                              
                            }
                            .frame(width: 300)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .offset(x: -10, y: 50)
                            .opacity(1)
                        
                        
                    }

                    
                }.padding()
                Spacer()
            }.opacity(viewModel.isLoading ? 0.3 : 1)
            VStack(alignment: .leading) {
                HStack{
                    Spacer()
                    Text(viewModel.errorMessage)
                    Spacer()
                }.foregroundColor(.red).opacity(viewModel.errorMessage.isEmpty ? 0 : 1)
                Text("Amount")
                TextField("", value: $viewModel.baseAmount , formatter: viewModel.numberFormatter).keyboardType(.decimalPad).focused($baseCurrencyIsFocused).onSubmit {
                    baseCurrencyIsFocused = false
                    convertedCurrencyIsFocused = false
                    viewModel.convert()
                }.font(.system(size: 20, weight: .medium)).padding(.vertical).padding(.horizontal, 3).overlay{
                    RoundedRectangle(cornerRadius: 5).fill(.clear).stroke(Color.gray, lineWidth: 1)
                }.overlay(alignment: .trailing) {
                    HStack{
                        viewModel.baseCurrency.image().resizable().scaledToFit().frame(width: 35, height: 35)
                        Menu {
                            ForEach(CurrencyChoice.allCases){ currencyChoice in
                                Button(action: {
                                    viewModel.baseCurrency = currencyChoice
                                }, label: {
                                    Text(currencyChoice.fetchMenuName())
                                })
                            }
                        } label: {
                            Text(viewModel.baseCurrency.rawValue).font(.system(size: 17, weight: .medium)).foregroundStyle(.black)
                            Image(systemName: "chevron.down").font(.system(size: 13, weight: .bold)).foregroundStyle(.black)
                        }
                        
                        
                    }.padding(.trailing, 5)
                }
                
                HStack{
                    Spacer()
                    Image(systemName: "arrow.up.arrow.down").padding(.top).font(.system(size: 20, weight: .medium)).onTapGesture {
                        viewModel.swapCurrencies()
                    }
                    Spacer()
                }
                
                Text("Converted To")
                TextField("", value: $viewModel.convertedAmount , formatter: viewModel.numberFormatter).keyboardType(.decimalPad).focused($convertedCurrencyIsFocused).font(.system(size: 20, weight: .semibold)).padding(.vertical).padding(.horizontal, 3).overlay{
                    RoundedRectangle(cornerRadius: 5).fill(.clear).stroke(Color.gray, lineWidth: 1)
                }.overlay(alignment: .trailing) {
                    HStack{
                        viewModel.convertedCurrency.image().resizable().scaledToFit().frame(width: 35, height: 35)
                        Menu {
                            ForEach(CurrencyChoice.allCases){convertedcurrency in
                                Button {
                                    viewModel.convertedCurrency = convertedcurrency
                                } label: {
                                    Text(convertedcurrency.fetchMenuName())
                                }
                                
                            }
                        } label: {
                            Text(viewModel.convertedCurrency.rawValue).font(.system(size: 17, weight: .medium)).foregroundStyle(.black)
                            Image(systemName: "chevron.down").font(.system(size: 13, weight: .bold)).foregroundStyle(.black)
                        }
                        
                    }.padding(.trailing, 5)
                    
                }
                HStack{
                    Spacer()
                    Button {
                        baseCurrencyIsFocused = false
                        convertedCurrencyIsFocused = false
                        viewModel.convert()
                    } label: {
                        Text("Convert").font(.system(size: 17, weight: .medium)).foregroundStyle(.white).padding(.vertical, 10).padding(.horizontal, 20).background(Color.blue).clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    .padding()
                    
                    Spacer()
                }
                
            }.opacity(viewModel.isLoading ? 0.2 : 1)
            .task {
                await viewModel.fetchRates() 
            }
            .padding()
            
            if viewModel.isLoading{
                ZStack{
                    Color.gray.opacity(0.5).ignoresSafeArea()
                    VStack{
                        ProgressView().tint(.white)
                        Text("Loading, Please Wait").font(.system(size: 18, weight: .bold)).foregroundStyle(.white).padding(.top,10)
                        
                        
                    }.padding(.bottom, 20)
//                    viewModel.errorMessage = "Please Wait!"
                }
            }
        }.onTapGesture {
            baseCurrencyIsFocused = false
            convertedCurrencyIsFocused = false
            viewModel.convert()
        }
        
    }
}

#Preview {
    ContentView()
}
