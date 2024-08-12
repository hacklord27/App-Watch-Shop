const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const app = express();
const port = 3000;

// Sử dụng body-parser để phân tích yêu cầu JSON
app.use(bodyParser.json());

// Thông tin người dùng giả lập để đăng nhập
const users = [
  { accountID: 'test', password: '1234' },
  // Bạn có thể thêm nhiều người dùng ở đây
];

// Danh sách các Category giả lập
const categories = [
  { id: 1, name: 'Casio', description: 'Đồng hồ thời trang Casio' },
  { id: 2, name: 'Đồng hồ thông minh ', description: 'Đồng hồ thông minh hiện đại' },
  // Thêm nhiều category hơn nếu cần
];

// Danh sách các sản phẩm giả lập
const products = [
  { id: 1, name: 'Đồng hồ Casio', description: 'Đồng hồ thời trang Casio', price: 1000, imageUrl: 'https://image.donghohaitrieu.com/wp-content/uploads/2023/03/MTP-M305D-1AVDF-MTP-M305L-7AVDF-MTP-M300L-7AVDF-MTP-M300D-7AVDF.jpg', categoryId: 1 },
  { id: 2, name: 'Đồng hồ thông minh ', description: 'Đồng hồ điện tử thông minh ', price: 2000, imageUrl: 'https://product.hstatic.net/1000391653/product/se2306231299145547_2c56fa547b5e481290dd8977d0efdbfe_1024x1024.jpg', categoryId: 2 },
  // Thêm nhiều sản phẩm hơn nếu cần
];

// Danh sách các hóa đơn giả lập
const bills = [
  { id: 1, products: [{ productID: 1, count: 1 }], total: 1000 },
  { id: 2, products: [{ productID: 2, count: 2 }], total: 4000 },
  // Thêm nhiều hóa đơn hơn nếu cần
];

// Endpoint đăng ký
app.post('/api/register', (req, res) => {
  const { accountID, password, confirmPassword } = req.body;
  console.log('Register request:', req.body);

  if (password !== confirmPassword) {
    return res.status(400).json({ status: 'error', message: 'Passwords do not match' });
  }

  const userExists = users.some(user => user.accountID === accountID);
  if (userExists) {
    return res.status(400).json({ status: 'error', message: 'User already exists' });
  }

  users.push({ accountID, password });
  console.log(users);
  res.json({ status: 'ok', message: 'Registration successful' });
});

// Endpoint đăng nhập
app.post('/api/login', (req, res) => {
  const { accountID, password } = req.body;
  console.log('Login request:', req.body);

  const user = users.find(u => u.accountID === accountID && u.password === password);

  if (user) {
    const token = jwt.sign({ accountID: user.accountID }, 'secret_key', { expiresIn: '1h' });
    res.json({ status: 'ok', token });
  } else {
    res.status(401).json({ status: 'error', message: 'Invalid accountID or password' });
  }
});

// Endpoint lấy danh sách các Category
app.get('/Category/getList', (req, res) => {
  console.log('Get Category List request:', req.query);
  res.json(categories);
});

// Endpoint thêm Category
app.post('/addCategory', (req, res) => {
  const { name, description, imageUrl, accountID } = req.body;
  console.log('Add Category request:', req.body);
  const newCategory = { id: categories.length + 1, name, description, imageUrl };
  categories.push(newCategory);
  res.status(200).json({ status: 'ok', message: 'Category added successfully' });
});

// Endpoint cập nhật Category
app.put('/updateCategory', (req, res) => {
  const { id, name, description, imageUrl, accountID } = req.body;
  console.log('Update Category request:', req.body);
  const category = categories.find(cat => cat.id === id);

  if (category) {
    category.name = name;
    category.description = description;
    category.imageUrl = imageUrl;
    res.status(200).json({ status: 'ok', message: 'Category updated successfully' });
  } else {
    res.status(404).json({ status: 'error', message: 'Category not found' });
  }
});

// Endpoint xóa Category
app.delete('/removeCategory', (req, res) => {
  const { categoryID, accountID } = req.body;
  console.log('Remove Category request:', req.body);
  const index = categories.findIndex(cat => cat.id === categoryID);

  if (index !== -1) {
    categories.splice(index, 1);
    res.status(200).json({ status: 'ok', message: 'Category removed successfully' });
  } else {
    res.status(404).json({ status: 'error', message: 'Category not found' });
  }
});

// Endpoint lấy danh sách các sản phẩm
app.get('/Product/getList', (req, res) => {
  const { accountID } = req.query;
  console.log('Get Product List request:', req.query);
  res.json(products);
});

// Endpoint lấy danh sách các sản phẩm admin
app.get('/Product/getListAdmin', (req, res) => {
  const { accountID } = req.query;
  console.log('Get Product List Admin request:', req.query);
  res.json(products);
});

// Endpoint lấy danh sách sản phẩm theo Category
app.get('/Product/getListByCatId', (req, res) => {
  const { categoryID, accountID } = req.query;
  console.log('Get Product List By Category ID request:', req.query);
  const filteredProducts = products.filter(product => product.categoryId == categoryID);
  res.json(filteredProducts);
});

// Endpoint thêm sản phẩm
app.post('/addProduct', (req, res) => {
  const { name, description, imageUrl, Price, CategoryID } = req.body;
  console.log('Add Product request:', req.body);
  const newProduct = { id: products.length + 1, name, description, price: Price, imageUrl, categoryId: CategoryID };
  products.push(newProduct);
  res.status(200).json({ status: 'ok', message: 'Product added successfully' });
});

// Endpoint cập nhật sản phẩm
app.put('/updateProduct', (req, res) => {
  const { id, name, description, imageUrl, Price, categoryID, accountID } = req.body;
  console.log('Update Product request:', req.body);
  const product = products.find(pro => pro.id === id);

  if (product) {
    product.name = name;
    product.description = description;
    product.price = Price;
    product.imageUrl = imageUrl;
    product.categoryId = categoryID;
    res.status(200).json({ status: 'ok', message: 'Product updated successfully' });
  } else {
    res.status(404).json({ status: 'error', message: 'Product not found' });
  }
});

// Endpoint xóa sản phẩm
app.delete('/removeProduct', (req, res) => {
  const { productID, accountID } = req.body;
  console.log('Remove Product request:', req.body);
  const index = products.findIndex(pro => pro.id === productID);

  if (index !== -1) {
    products.splice(index, 1);
    res.status(200).json({ status: 'ok', message: 'Product removed successfully' });
  } else {
    res.status(404).json({ status: 'error', message: 'Product not found' });
  }
});

// Endpoint thêm hóa đơn
app.post('/Order/addBill', (req, res) => {
  const listProduct = req.body;
  console.log(listProduct);
  if (!listProduct) {
    return res.status(400).json({ status: 'error', message: 'Invalid products data'});
  }

  try {
    var sum = 0;
    for(var i of listProduct){
      var quantity = i['count'];
      var price = i['price'];
      var total = price * quantity;
      sum += total;
      console.log(sum);
    }

    const newBill = { id: bills.length + 1, products: listProduct, total: sum, dateCreated: Date.now()};
    bills.push(newBill);

    res.status(200).json({ status: 'ok', message: 'Bill added successfully'});
  } catch (error) {
    console.error('Error processing bill:', error);
    res.status(500).json({ status: 'error', message: 'Server error' });
  }
});

// Endpoint lấy lịch sử hóa đơn
app.get('/Bill/getHistory', (req, res) => {
  console.log('Get Bill History request:', bills);
  res.json(bills);
});

// Endpoint lấy chi tiết hóa đơn
app.post('/Bill/getByID', (req, res) => {
  const { billID } = req.query;
  console.log('Get Bill By ID request:', req.query);
  const bill = bills.find(b => b.id == billID);

  if (bill) {
    res.json(bill);
  } else {
    res.status(404).json({ status: 'error', message: 'Bill not found' });
  }
});

// Endpoint xóa hóa đơn
app.delete('/Bill/remove', (req, res) => {
  const { billID } = req.query;
  console.log('Remove Bill request:', req.query);
  const index = bills.findIndex(b => b.id == billID);

  if (index !== -1) {
    bills.splice(index, 1);
    res.status(200).json({ status: 'ok', message: 'Bill removed successfully' });
  } else {
    res.status(404).json({ status: 'error', message: 'Bill not found' });
  }
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
