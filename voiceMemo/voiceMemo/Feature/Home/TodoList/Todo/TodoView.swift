//
//  TodoView.swift
//  voiceMemo
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()
                },
                rightBtnAction: {
                    todoListViewModel.addTodo(
                        .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.day,
                            selected: false
                        )
                    )
                    pathModel.paths.removeLast()
                },
                rightBtnType: .create
            )
        }
    }
}

// MARK: - TitleView
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("To do List를\n추가해 보세요.")
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoTitleView
private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $todoViewModel.title)
    }
}

}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
