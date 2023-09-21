import { RoleName } from '@prisma/client'

import { RefreshIconDefinition } from 'entities/Refresh'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Refreshes() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const refreshes = await prisma.refresh.findMany({
    orderBy: {
      created: 'desc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={RefreshIconDefinition}
          title="Refreshes"
          subtitle={`${refreshes.length}`}
        />

        <EntityList
          items={refreshes.map((refresh) => ({
            icon: RefreshIconDefinition,
            href: `/admin/refreshes/${refresh.id}`,
            subtitle: refresh.subscriptionId,
            text: refresh.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
