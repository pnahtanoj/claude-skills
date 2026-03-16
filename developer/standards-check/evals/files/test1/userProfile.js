import { formatDate } from './utils'
import axios from 'axios'

const maxRetries = 3

export async function fetchUserProfile(userId) {
  const response = await axios.get(`/api/users/${userId}`)
  return response.data
}

export function updateProfile(data) {
  return axios.post('/api/users/update', data)
}

export async function deleteUser(userId) {
  try {
    await axios.delete(`/api/users/${userId}`)
  } catch (e) {
    // ignore
  }
}
