import React from 'react'

export function Select({
  children,
  className = "",
  ...props
}) {
  return (
    <select 
      className={`form-select ${className}`}
      {...props}
    >
      {children}
    </select>
  )
}

export function SelectItem({ className = "", ...props }) {
  return (
    <option 
      className={className}
      {...props} 
    />
  )
}

export default Select