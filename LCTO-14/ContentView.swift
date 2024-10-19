import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject private var viewModelImages = ViewModelImages()

    private let maxCharacters = 88
    @State private var showImagePicker = false
    @State private var selectedImageType: ImageType?
    @State private var showErrorMessage = false

    enum ImageType {
        case before, after
    }

    var body: some View {
        VStack(spacing: 20) {
            // Display star ratings
            StarView(rating: viewModel.averageRating)
                .padding(.top, -15)

            ScrollView {
                VStack(spacing: 20) {
                    // Search bar and search button
                    TextField("Search, then press Search-Product", text: $viewModel.userInput3)
                        .padding(.top, 0.5)
                        .frame(width: UIScreen.main.bounds.width * 0.82)
                        .bold()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.userInput3) { newValue in
                            // If the input is empty, reset the search results and message
                            if newValue.isEmpty {
                                viewModel.searchMessage = ""
                                viewModel.hasSearched = false
                                viewModel.searchResults = []
                            }
                        }



                    Button("Search Product") {
                        if viewModel.userInput3.isEmpty {
                            viewModel.searchMessage = "Please enter a product name to search."
                            showErrorMessage = true
                            // Hide the error message after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showErrorMessage = false
                                }
                            }
                        } else {
                            viewModel.fetchProductNames(searchTerm: viewModel.userInput3)
                            viewModel.calculateAverageRating(for: viewModel.userInput3)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)

                    // Error message display with animation
                    if showErrorMessage {
                        Text(viewModel.searchMessage)
                            .foregroundColor(.red)
                            .padding()
                            .bold()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: showErrorMessage)
                    }

                    // Display search results or the "No results found" message.
                    if !viewModel.searchResults.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.searchResults, id: \.self) { comment in
                                Text(comment)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    } else if viewModel.hasSearched && viewModel.searchResults.isEmpty {
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.black) // Using black as requested
                            .padding()
                    }



                    Spacer()

                    // Product and comment submission section
                    VStack(spacing: 10) {
                        TextField("Post product name here", text: $viewModel.userInput)
                            .frame(width: UIScreen.main.bounds.width * 0.82)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .bold()
                        
                        TextField("Enter Stars 0-5. Tap a bottle to shed KB", text: $viewModel.userInput4)
                            .frame(width: UIScreen.main.bounds.width * 0.82)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .bold()
                        
                        TextField("Comment here. Tap a bottle to shed KB", text: $viewModel.userInput2)
                            .frame(width: UIScreen.main.bounds.width * 0.92)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .bold()
                            .onChange(of: viewModel.userInput2) { newValue in
                                if newValue.count > maxCharacters {
                                    viewModel.userInput2 = String(newValue.prefix(maxCharacters))
                                }
                            }

                        // Character counter display
                        Text("\(viewModel.userInput2.count)/\(maxCharacters) characters")
                            .font(.caption)
                            .foregroundColor(.black)
                            .bold()

                        // Submit button for posting a comment
                        Button(action: {
                            viewModel.postComment(
                                productName: viewModel.userInput,
                                comment: viewModel.userInput2,
                                rating: viewModel.userInput4
                            )
                        }) {
                            Text("POST comment")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }

            // Spacer to keep layout tidy
            Spacer()

            // Add the Before/After image buttons on the landing screen
            HStack {
                Button(action: {
                    selectedImageType = .before
                    showImagePicker = true
                }) {
                    Image(systemName: "arrowshape.turn.up.left.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    Text("Before")
                }

                Spacer()

                Button(action: {
                    selectedImageType = .after
                    showImagePicker = true
                }) {
                    Image(systemName: "arrowshape.turn.up.right.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    Text("After")
                }
            }
            .padding()
        }
        .padding()
        .background(Image("shelves").resizable().aspectRatio(contentMode: .fill).opacity(0.4).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                selectedImage: selectedImageType == .before ? $viewModelImages.beforeImage : $viewModelImages.afterImage,
                isPresented: $showImagePicker
            )
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct StarView: View {
    var rating: Double

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: starType(index: index))
                    .foregroundColor(index < Int(ceil(rating)) ? .red : .gray)
            }
        }
    }
    
    private func starType(index: Int) -> String {
        if Double(index) < rating - 0.5 {
            return "star.fill"
        } else if Double(index) < rating && rating - Double(index) >= 0.5 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(rating: 3.5)
    }
}

struct BeforeAfterImageView: View {
    @Binding var selectedImageType: ContentView.ImageType?
    @ObservedObject var viewModel: ViewModelImages

    @State private var showImagePicker = false

    var body: some View {
        VStack {
            // Display the selected image
            if selectedImageType == .before, let beforeImage = viewModel.beforeImage {
                VStack {
                    Text("Before Image:")
                    Image(uiImage: beforeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            } else if selectedImageType == .after, let afterImage = viewModel.afterImage {
                VStack {
                    Text("After Image:")
                    Image(uiImage: afterImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }

            Spacer()

            // Camera Button to capture a new image
            Button(action: {
                showImagePicker = true
            }) {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Spacer()

            // Save and Cancel buttons
            HStack {
                Button(action: {
                    if selectedImageType == .before {
                        viewModel.uploadBeforeImage()
                    } else if selectedImageType == .after {
                        viewModel.uploadAfterImage()
                    }
                    selectedImageType = nil // Close the view after saving
                }) {
                    Text("SAVE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }

                Button(action: {
                    if selectedImageType == .before {
                        viewModel.beforeImage = nil
                    } else if selectedImageType == .after {
                        viewModel.afterImage = nil
                    }
                    selectedImageType = nil // Close the view after cancelling
                }) {
                    Text("CANCEL")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                selectedImage: selectedImageType == .before ? $viewModel.beforeImage : $viewModel.afterImage,
                isPresented: $showImagePicker
            )
        }
    }
}

