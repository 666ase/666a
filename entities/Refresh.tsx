import { faRotate } from '@fortawesome/free-solid-svg-icons/faRotate'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const RefreshIconDefinition = faRotate

export const RefreshIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={RefreshIconDefinition} />
}