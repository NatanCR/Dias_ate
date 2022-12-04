//
//  HomeView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var eventoModel: EventoViewModel
    
    @State private var dataInicio = Date()
    @State private var dataFinal = Date()
    @State private var mostrarTela = false
    
    private let grid = [
        GridItem(.adaptive(minimum: 120, maximum: 200))
    ]
    
    var periodo: ClosedRange<Date>{
        let max = Calendar.current.date(byAdding: .year, value: 15, to: Date())!
        return Date()...max
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .center) {
                        Text("Calcule os dias")
                            .font(.system(size: 20,
                                          weight: .bold,
                                          design: .rounded))
                            .padding(.top, 40)
                            .accessibilityRemoveTraits(.isStaticText)
                        Text("até seu evento")
                            .font(.system(size: 20,
                                          weight: .bold,
                                          design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 250, height: 200)
                                .foregroundColor(Color.init(red: 0.89, green: 0.92, blue: 0.94, opacity: 1.00))
                            VStack{
                                VStack {
                                    Text("Data de hoje")
                                        .font(.system(size: 18,
                                                      weight: .semibold,
                                                      design: .default))
                                    
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                        .accessibilityRemoveTraits(.isStaticText)
                                    
                                    
                                    Text(ConversorData.conversorDataString(dataParaConversao: Date(), recebeData: "dataHome"))
                                        .accessibilityRemoveTraits(.isStaticText)
                                }
                                .padding()
                                VStack {
                                    Text("Data do seu evento")
                                        .font(.system(size: 20,
                                                      weight: .semibold,
                                                      design: .default))
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                        .accessibilityRemoveTraits(.isStaticText)
                                    DatePicker("", selection: $dataFinal,
                                               in: periodo,
                                               displayedComponents: [.date])
                                    .labelsHidden()
                                    .environment(\.locale, Locale.init(identifier: "pt_BR"))
                                    
                                }
//                                .id(dataFinal)
                                .onAppear {
                                    dataInicio = Date()
                                    dataFinal = Date()
                                    Avaliacao.pedidoAvaliacao()
                                }
                            }
                        }
                        LazyVGrid(columns: grid, spacing: 30) {
                            ZStack {
                                VStack{
                                    Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos"))")
                                        .accessibilityRemoveTraits(.isStaticText)
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos"))") == "1" {
                                        Text("Dia corrido")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }else {
                                        Text("Dias corridos")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "semanas"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                        .accessibilityRemoveTraits(.isStaticText)
                                    if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "semanas"))") == "1" {
                                        Text("Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    } else{
                                        Text("Semanas")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "uteis"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                        .accessibilityRemoveTraits(.isStaticText)
                                    if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "uteis"))") == "1" {
                                        Text("Dia de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    } else {
                                        Text("Dias de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "finais"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                        .accessibilityRemoveTraits(.isStaticText)
                                    if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "finais"))") == "1" {
                                        Text("Final de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }else{
                                        Text("Finais de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .multilineTextAlignment(.center)
                                            .accessibilityRemoveTraits(.isStaticText)
                                    }
                                }
                            }
                        }
                        .padding([.top, .leading, .trailing],30)
                        Spacer()
                    }
                    
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AdicionarEventoView(eventoModel: eventoModel, dataFinalSalvar: dataFinal, dataLembrete: Date(), mostrarTela: $mostrarTela), isActive: $mostrarTela) {
                                Text("Adicionar")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                
                            }
                            .disabled(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos") == 0)
                        }
                    }
                }
            }
            .navigationBarTitle("Contador")
            .background(Color.init(red: 0.77, green: 0.84, blue: 0.90, opacity: 1.00))
            .navigationAppearance(backgroundColor: UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00), foregroundColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), tintColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), hideSeparator: true)
        }
        .navigationViewStyle(.stack)
    }
}
