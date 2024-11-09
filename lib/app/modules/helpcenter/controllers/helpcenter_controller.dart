import 'package:get/get.dart';

class HelpcenterController extends GetxController {
  
  // Accordion data
  final faqData = [
  {
    'title': 'Viewing Beverage Menu Details',
    'content': 
        '1. On the Home page, select the "Beverages" tab.\n'
        '2. You will see a series of beverage cards. On each card, there is a teal button with a cart icon and an arrow.\n'
        '3. Tap this button to view detailed information about the beverage, including its name, description, and detailed pricing options for different sizes.'
  },
  {
    'title': 'Viewing Coffee Powder Menu Details',
    'content': 
        '1. On the Home page, select the "Coffee Powder" tab.\n'
        '2. A set of coffee powder menu cards will appear. Each card includes a teal button with a cart icon and an arrow.\n'
        '3. Tap this button to access the menu details, which include the item’s name, description, availability location, and complete pricing information based on weight options.'
  },
  {
    'title': 'Adding Favorite Items',
    'content': 
        '1. On the detail page for either beverages or coffee powder items, there is a heart-shaped favorite icon at the top right.\n'
        '2. Tap this icon to add the item to your "My Favorite" list. This list is accessible from the Main Profile page, where all favorite items will be displayed.'
  },
  {
    'title': 'Adding Items to the Cart',
    'content': 
        '1. On the beverage or coffee powder detail page, select a quantity and size.\n'
        '2. Tap the "Add to Cart" button at the bottom of the page.\n'
        '3. You will be redirected to the Cart page where your newly added item will appear, ready for checkout.'
  },
  {
    'title': 'Placing an Order',
    'content': 
        '1. On the Cart page, after adding at least one item, select a payment method (Visa/MasterCard, Dana, or LinkAja).\n'
        '2. Tap "Create Order" to place the order.\n'
        '3. You can track the order’s progress through the "My Orders" page.'
  },
  {
    'title': 'Tracking Orders',
    'content': 
        '1. On the My Orders page, you can view each order card, which includes the order ID, item details, and current status.\n'
        '2. Statuses include:\n'
        '    - Order Received: The order is awaiting admin confirmation.\n'
        '    - Being Prepared: The admin has accepted your order, and it is being prepared.\n'
        '    - Ready for Pickup: The order is ready for pickup at the store.\n'
        '    - Picked Up: You have picked up the order.\n'
        '3. Once an order reaches "Picked Up," it will be moved to the "My Order History" page.'
  },
  {
    'title': 'Viewing Order History',
    'content': 
        '1. Access your order history in the "My Order History" page.\n'
        '2. A date filter is available to sort orders by specific dates.\n'
        '3. Tap the statistics section at the bottom of the page to view your order analysis.'
  },
  {
    'title': 'Viewing Order Statistics',
    'content': 
        '1. In the Analysis Order History page, tabs show your total spending, ordered items, completed orders, and canceled orders.\n'
        '2. A bar chart represents each of these statistics, giving a quick overview of your order history.'
  },
  {
    'title': 'Viewing Favorite Items',
    'content': 
        '1. Go to the "My Favorite" page to view your saved beverage or coffee powder items.\n'
        '2. You can place an order for a favorite item by tapping the cart icon and arrow button on each item card.'
  },
  {
    'title': 'Viewing Store Locations on Google Maps',
    'content': 
        '1. Visit the "Our Location" page to view available store locations.\n'
        '2. Select either "Pasar Tambak Rejo, Surabaya" or "CitraLand CBD Boulevard, Surabaya".\n'
        '3. A Google Maps section will appear, showing the exact location of the chosen store.'
  },
  {
    'title': 'Updating Account Information',
    'content': 
        '1. On the Main Profile page, tap "Update Account".\n'
        '2. You will be directed to a page where you can select a new avatar, update your username, and phone number.'
  },
  {
    'title': 'Changing Password',
    'content': 
        '1. In the Main Profile, tap "Change Password".\n'
        '2. Enter your email, old password, and new password to complete the change.'
  },
  {
    'title': 'Deleting Account',
    'content': 
        '1. From the Main Profile, tap "Delete Account".\n'
        '2. Enter your email, password, and confirm "DELETE" to proceed with account deletion.'
  },
  {
    'title': 'Logging Out',
    'content': 
        '1. To log out, tap the red logout icon at the top right of the Main Profile page.'
  },
].obs;

  // Accordion state
  final isAccordionOpen = false.obs;
  final openedIndex = (-1).obs;

  void toggleAccordion(int index) {
    if (openedIndex.value == index) {
      isAccordionOpen.value = !isAccordionOpen.value;
    } else {
      isAccordionOpen.value = true;
      openedIndex.value = index;
    }
  }
}