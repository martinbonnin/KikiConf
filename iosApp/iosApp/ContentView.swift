import SwiftUI
import Combine
import shared


struct ContentView: View {
    @StateObject var viewModel = KikiConfViewModel()

    var body: some View {
        TabView {
            SessionListView(viewModel: viewModel)
                .tabItem {
                    Label("Sessions", systemImage: "film")
                }
            SpeakerListView(viewModel: viewModel)
                .tabItem {
                    Label("Speakers", systemImage: "person")
                }
            RoomListView(viewModel: viewModel)
                .tabItem {
                    Label("Rooms", systemImage: "location")
                }

        }
    }
}

struct SessionListView: View {
    @ObservedObject var viewModel: KikiConfViewModel

    var body: some View {
        NavigationView {
            List(viewModel.sessions, id: \.id) { session in
                NavigationLink(destination: SessionDetailsView(session: session)) {
                    VStack(alignment: .leading) {
                        Text(session.title).font(.headline)
                    }
                }
            }
            .navigationTitle("Sessions")
            .onAppear {
                viewModel.startObservingSessions()
            }
            .onDisappear {
                viewModel.stopObservingSessions()
            }
        }
    }
}

struct SessionDetailsView: View {
    var session: Session

    var body: some View {
        VStack {
            Text(session.title)
            Divider()
            
            Text(session.desc)
            
            Spacer()
        }
    }
}


struct SpeakerListView: View {
    @ObservedObject var viewModel: KikiConfViewModel

    var body: some View {
        NavigationView {
            List(viewModel.speakers, id: \.id) { speaker in
                VStack(alignment: .leading) {
                    SpeakerView(speaker: speaker)
                }
            }
            .navigationTitle("Speakers")
            .onAppear {
                viewModel.startObservingSpeakers()
            }
            .onDisappear {
                viewModel.stopObservingSpeakers()
            }
        }
    }
}


struct SpeakerView: View {
    var speaker: Speaker
    
    var body: some View {
        HStack {
            if let image = speaker.photoUrl,
               let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            VStack(alignment: .leading) {
                Text(speaker.name).font(.headline)
                Text(speaker.company ?? "").font(.subheadline)
            }
        }
    }
}


struct RoomListView: View {
    @ObservedObject var viewModel: KikiConfViewModel

    var body: some View {
        NavigationView {
            List(viewModel.rooms, id: \.id) { room in
                VStack(alignment: .leading) {
                    Text(room.name).font(.headline)
                }
            }
            .navigationTitle("Rooms")
            .onAppear {
                viewModel.startObservingRooms()
            }
            .onDisappear {
                viewModel.stopObservingRooms()
            }

        }
    }
}


