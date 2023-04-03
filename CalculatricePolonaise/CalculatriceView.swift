//
//  CalculatriceView.swift
//  CalculatricePolonaise
//
//  Created by Salah Filali on 27/1/2023.
//

import SwiftUI

enum Operation {
    case add, subtract, multiply, divide, power, none
}

struct CalculatriceView: View {
    
    @ObservedObject var viewModel = CalculatriceViewModel()

    let buttons: [[CalculatorButton]] = [
        [.clear, .power, .factorial, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    Text(viewModel.workingSpaceText)
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Spacer()
                    // Text display
                    HStack {
                        Spacer()
                        Text(viewModel.value)
                            .bold()
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .padding()
                }

                // buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.viewModel.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }.alert(viewModel.errorMessage, isPresented: $viewModel.isShowingError) {
            Button("OK", role: .cancel) {
                self.viewModel.clear()
            }
        }
    }

    func buttonWidth(item: CalculatorButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct CalculatriceView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatriceView()
    }
}
