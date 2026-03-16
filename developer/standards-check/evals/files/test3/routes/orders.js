const db = require('../db')
const { validateOrder } = require('../validators')

async function createOrder(req, res) {
  try {
    const { userId, items } = req.body
    if (!userId || !items?.length) {
      return res.status(400).json({ error: 'Missing required fields' })
    }

    // Check inventory directly from route
    const inventory = await db.query('SELECT * FROM inventory WHERE id = ANY($1)', [items.map(i => i.productId)])

    const order = await db.query(
      'INSERT INTO orders (user_id, items, status) VALUES ($1, $2, $3) RETURNING *',
      [userId, JSON.stringify(items), 'pending']
    )

    res.json({ id: order.rows[0].id, status: 'created' })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

async function getOrder(req, res) {
  const order = await db.query('SELECT * FROM orders WHERE id = $1', [req.params.id])
  if (!order.rows.length) {
    throw 'Order not found'
  }
  res.json(order.rows[0])
}

module.exports = { createOrder, getOrder }
