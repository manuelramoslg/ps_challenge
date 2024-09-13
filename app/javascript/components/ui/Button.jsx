import React from 'react'

const variants = {
  default: "btn-primary",
  destructive: "btn-danger",
  outline: "btn-outline-primary",
  secondary: "btn-secondary",
  ghost: "btn-link",
  link: "btn-link",
}

const sizes = {
  default: "",
  sm: "btn-sm",
  lg: "btn-lg",
}

export function Button({
  className = "",
  variant = "default",
  size = "default",
  ...props
}) {
  return (
    <button
      className={`btn ${variants[variant]} ${sizes[size]} ${className}`}
      {...props}
    />
  )
}

export default Button