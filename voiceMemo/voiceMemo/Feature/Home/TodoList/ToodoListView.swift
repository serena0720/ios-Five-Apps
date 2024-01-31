//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
            
            WriteTodoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) { }
        }
    }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do List를\n추가해 보세요.")
            } else {
                Text("To do List \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15,
               content: {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")
            
            Spacer()
        })
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0,
                       content: {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \Todo.self) { todo in
                        TodoCellView(todo: todo)
                    }
                })
            }
        }
    }
}

// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemovedSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemovedSelected: Bool = false,
        todo: Todo
    ) {
        _isRemovedSelected = State(initialValue: isRemovedSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button(
                        action: { todoListViewModel.selectedBoxTapped(todo) },
                        label: {
                            todo.selected ? Image("selectedBox") : Image("unselectedBox")
                        }
                    )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button(
                        action: {
                            isRemovedSelected.toggle()
                            todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                        },
                        label: {
                            isRemovedSelected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - TodoList 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.todoView)
                    },
                    label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}
