//import SwiftUI
//struct CheckScreenWithRole: View {
//    @EnvironmentObject var language: LanguageManager
//    @Binding var selectedTab: Int
//    @Binding var isUnlockBio: Bool
//    var role: UserRoles
//    var body: some View {
//        switch selectedTab {
//        case 0:
//            if role == .admin{
//                HomeView(isUnlocked: $isUnlockBio)
//            }else if(role == .student){
//                StudentHome(isUnlocked: $isUnlockBio,overViewModel: overViewModel)
//            }else{
//                StaffHome(isUnlocked: $isUnlockBio,overViewModel: overViewModel)
//            }
//        case 1:
//            if role == .admin{
//                AdminAttendenceView()
//            }else if(role == .student) {
//                StudentAttendenceView()
//            } else {
//                StaffAttendenceView()
//            }
//        case 2:
//            if role == .admin{
//                ScheduleView()
//            }else{
//                EmptyView()
//            }
//        case 3:
//            RequestView(role: role)
//        case 4:
//            if role == . admin {
//                ProfileAdminView()
//                    .environmentObject(profileViewMode)
//            }else if role == .staff{
//                ProfileStaffView()
//                    .environmentObject(profileViewMode)
//            }else{
//                ProfileStudentView()
//                    .environmentObject(profileViewMode)
//            }
//        default:
//            HomeView(isUnlocked: $isUnlockBio)
//        }
//    }
//}
