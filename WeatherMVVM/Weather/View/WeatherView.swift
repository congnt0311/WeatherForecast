//
//  ContentView.swift
//  Weather
//

import SwiftUI

struct WeatherView: View {

  @ObservedObject var viewModel: WeatherViewModel

  var body: some View {
      ZStack {
          Image("light_background")
              .resizable()
              .scaledToFill()
              .edgesIgnoringSafeArea(.all)
          VStack{
              Text(viewModel.cityName).font(.system(size: 70))
  
              Text(viewModel.temperature)
                  .font(.system(size: 64))
                  .bold()
              Text(viewModel.weatherDescription).font(.system(size: 32))
          }

      }

    .alert(isPresented: $viewModel.shouldShowLocationError) {
      Alert(
        title: Text("Error"),
        message: Text("To see the weather, provide location access in Settings."),
        dismissButton: .default(Text("Open Settings")) {
          guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
          UIApplication.shared.open(settingsURL)
        }
      )
    }
    .onAppear(perform: viewModel.refresh)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
  }
}
