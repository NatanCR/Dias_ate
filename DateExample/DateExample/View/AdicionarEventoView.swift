//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation
import SwiftUI

struct AdicionarEventoView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State private var selecionarCalendario = 1
    @State var dataFinalSalvar = Date()
    @State private var alertasIndex = 0
    @State private var titulo: String = ""
    @State private var anotacao: String = ""
    @State var id: UUID?
    @State private var modoEditar = false
    @State var dataLembrete: Date
    @State private var ativaLembrete = false
    @State private var ativaCalendario = false
    @State private var mostrarAlerta = false
    @Environment(\.currentTab) var tab
    @Binding var mostrarTela: Bool
    private let altura = UIScreen.main.bounds.size.height
    
    enum MenuCalendario: String, CaseIterable, Identifiable {
        case selecione
        case lista

        var id: String { self.rawValue }
    }
    
    @State private var selecionaCalendario = MenuCalendario.selecione
    
    var body: some View {
        VStack {
            VStack {
                Text("\(ConversorData.conversorDataString(dataParaConversao: dataFinalSalvar, recebeData: ""))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
                Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos")) dias corridos")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
            }
            .padding()
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .accessibilityRemoveTraits(.isStaticText)
                            .accessibility(hint: Text("Titulo do seu evento"))
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(titulo.publisher.collect()) {
                                titulo = String($0.prefix(20))
                            }
                        HStack {
                            Text("Data do evento")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                            Spacer()
                            DatePicker("", selection: $dataFinalSalvar,
                                       in: Date()...Date.distantFuture,
                                       displayedComponents: [.date])
                        }
                    }
                    
                    Section() {
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                            
                        }
                        .accessibilityHint(Text("Ative para receber notificação do seu evento"))
                        if ativaLembrete == true {
                            HStack {
                                Spacer()
                                DatePicker("", selection: $dataLembrete,
                                           in: Date()...Date.distantFuture,
                                           displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .datePickerStyle(.automatic)
                                    .environment(\.locale, Locale.init(identifier: "pt_BR"))
                                    .accessibilityHint(Text("Escolha a data para receber a notificacao"))
                                Spacer()
                            }
                        }
                    }
                    .id(dataLembrete)
                    
                    Section() {
                        Toggle(isOn: $ativaCalendario) {
                            Text("Adicionar ao Calendário")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }.accessibilityHint(Text("Evento será adicionado no calendário"))
                        if ativaCalendario{
//                            // levar para outra view para selecionar qual calendario sera adicionado o evento
                            HStack {
                                Text("Calendário")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                Spacer()
                                Picker("",selection: $selecionarCalendario) {
                                    ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
                                        if eventoModel.listaCalendario[evento].title != "Feriados" && eventoModel.listaCalendario[evento].title != "Sugestões da Siri" && eventoModel.listaCalendario[evento].title != "Aniversários" {
                                            Text(eventoModel.listaCalendario[evento].title).tag(evento)
                                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                        }
                                        
                                    }
                                }
                                .pickerStyle(.menu)
                                Image(systemName: "chevron.up.chevron.down")
                                    .offset(x: -5)
                            }
                        }
                    }
                    
                    Section(header: Text("Notas")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                                .foregroundColor(Color.gray)){
                        TextEditor(text: $anotacao)
                            .accessibilityHint(Text("Adicione uma nota ao seu evento"))
                            .frame(height: altura * 0.2)
                    }
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                }
            }
            .onTapGesture{
                eventoModel.esconderTeclado()
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Adicionar evento")
        
        .navigationBarBackButtonHidden(true)
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira um título ao evento."), dismissButton: .default(Text("Ok")))
                
                
            }else{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira a data de notificação anterior a data do evento."), dismissButton: .default(Text("Ok")))
            }
        }
        .accessibilityRemoveTraits(.isStaticText)
        .accessibilityRemoveTraits(.isHeader)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    mostrarTela = false
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("Contador")
                    }
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    titulo = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
                    if titulo == "" || dataLembrete > dataFinalSalvar {
                        self.mostrarAlerta.toggle()
                    } else {
                        
                        eventoModel.adicionarNovo(tituloSalvo: titulo,
                                                  anotacoesSalvo: anotacao,
                                                  dataFinalSalvo: dataFinalSalvar,
                                                  dataLembrete: dataLembrete,
                                                  ativaLembrete: ativaLembrete,
                                                  idLembrete: UUID(),
                                                  adicionarCalendario: ativaCalendario,
                                                  selecionarCalendario: selecionarCalendario)
                        Notificacoes.permissao()
                        mostrarTela = false
                        tab.wrappedValue = .lista
                    }
                } label: {
                    Text("Salvar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}
