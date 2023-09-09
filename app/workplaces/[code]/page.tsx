import { faBuilding, faFileLines } from '@fortawesome/free-solid-svg-icons'
import Link from 'next/link'

import { IconHeading } from '../../../components/IconHeading'
import { IconLink } from '../../../components/IconLink'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/Table'
import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Workplace({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const workplace = await prisma.workplace.findFirstOrThrow({
    where: { code: params.code },
    include: { documents: { include: { case: true, type: true } } },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <IconHeading icon={faBuilding}>{workplace.name}</IconHeading>
          <p className="text-lg text-muted-foreground">{workplace.code}</p>
        </div>

        <h2 className="pt-8 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Documents
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Type</TableHead>
              <TableHead>Case</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {workplace.documents.map((d: any) => (
              <TableRow key={d.id}>
                <TableCell>
                  <IconLink href={`/documents/${d.code}`} icon={faFileLines}>
                    {d.code}
                  </IconLink>
                </TableCell>
                <TableCell>{d.type?.name}</TableCell>
                <TableCell>
                  <Link href={`/cases/${d.case?.code}`}>{d.case.name}</Link>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}